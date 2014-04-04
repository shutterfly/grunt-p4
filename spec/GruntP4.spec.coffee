describe 'grunt-p4', ->

  gruntP4 = null
  mockGrunt = null
  tasks = null
  taskContext = null
  asyncCallback = null
  mockError = null

  beforeEach ->
    createMockGrunt()
    mockError = 'simulated exec error'
    gruntP4 = require("#{process.cwd()}/dist/grunt-p4.js")(mockGrunt)

  createMockGrunt = ->
    tasks = {}
    mockGrunt =
      registerMultiTask: jasmine.createSpy('registerMultiTask')
      verbose:
        writeln: jasmine.createSpy('verbose.writeln')
      util:
        spawn: jasmine.createSpy('util.spawn')
      log:
        error: jasmine.createSpy('log.error')
        writeln: jasmine.createSpy('log.writeln')

    mockGrunt.registerMultiTask.andCallFake (name, info, fn) ->
      tasks[name] = fn

    return mockGrunt

  createTaskContext = (options) ->
    asyncCallback = jasmine.createSpy('asyncCallback')

    taskContext = jasmine.createSpyObj('task', ['options', 'async'])
    taskContext.options.andCallFake (defaults) ->
      return options ? defaults
    taskContext.async.andReturn(asyncCallback)

    return taskContext

  describe 'initialization', ->

    it 'registers the p4revert task', ->
      registerArgs = mockGrunt.registerMultiTask.argsForCall[0]
      expect(registerArgs[0]).toEqual('p4revert')
      expect(registerArgs[1]).toEqual('Revert files in Perforce')

    it 'registers the p4sync task', ->
      registerArgs = mockGrunt.registerMultiTask.argsForCall[1]
      expect(registerArgs[0]).toEqual('p4sync')
      expect(registerArgs[1]).toEqual('Synchronize files in Perforce')

    it 'registers the p4edit task', ->
      registerArgs = mockGrunt.registerMultiTask.argsForCall[2]
      expect(registerArgs[0]).toEqual('p4edit')
      expect(registerArgs[1]).toEqual('Edit files in Perforce')

    it 'registers the p4submit task', ->
      registerArgs = mockGrunt.registerMultiTask.argsForCall[3]
      expect(registerArgs[0]).toEqual('p4submit')
      expect(registerArgs[1]).toEqual('Submit files in Perforce')

  describe 'p4revert', ->

    beforeEach ->
      options =
        paths: ['path1', 'path2']
      taskContext = createTaskContext(options)
      tasks.p4revert.apply(taskContext)

    it 'registers default options', ->
      expect(taskContext.options).toHaveBeenCalledWith({paths: []})

    it 'spawns perforce command with expected arguments', ->
      expect(mockGrunt.util.spawn).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      expect(spawnArgs[0].cmd).toEqual('p4')
      expect(spawnArgs[0].args[0]).toEqual('revert')
      expect(spawnArgs[0].args[1]).toEqual('path1')
      expect(spawnArgs[0].args[2]).toEqual('path2')

    it 'invokes async callback on completion', ->
      expect(taskContext.async).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      spawnHandler = spawnArgs[1]
      spawnHandler(mockError)
      expect(asyncCallback).toHaveBeenCalledWith(mockError)

  describe 'p4sync', ->

    invokeP4Sync = (options) ->
      taskContext = createTaskContext(options)
      tasks.p4sync.apply(taskContext)

    invokeDefault = ->
      options =
        paths: ['path1', 'path2']
      invokeP4Sync(options)

    invokeWithPreview = ->
      options =
        preview: true
        paths: ['path1', 'path2']
      invokeP4Sync(options)

    invokeWithForce = ->
      options =
        force: true
        paths: ['path1', 'path2']
      invokeP4Sync(options)

    it 'registers default options', ->
      invokeDefault()
      expect(taskContext.options).toHaveBeenCalledWith({preview: false, force: false, paths: []})

    it 'spawns perforce command with expected arguments', ->
      invokeDefault()
      expect(mockGrunt.util.spawn).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      expect(spawnArgs[0].cmd).toEqual('p4')
      p4args = spawnArgs[0].args
      expect(p4args.length).toEqual(3)
      expect(p4args[0]).toEqual('sync')
      expect(p4args[1]).toEqual('path1')
      expect(p4args[2]).toEqual('path2')

    it 'spawns perforce command in preview mode when preview option is true', ->
      invokeWithPreview()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      p4args = spawnArgs[0].args
      expect(p4args.length).toEqual(4)
      expect(p4args[1]).toEqual('-n')

    it 'spawns perforce command in force sync mode when force option is true', ->
      invokeWithForce()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      p4args = spawnArgs[0].args
      expect(p4args.length).toEqual(4)
      expect(p4args[1]).toEqual('-f')

    it 'spawns perforce command in force sync with preview when both options are true', ->
      options =
        preview: true
        force: true
        paths: ['path1', 'path2']
      invokeP4Sync(options)
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      p4args = spawnArgs[0].args
      expect(p4args.length).toEqual(5)
      expect(p4args[1]).toEqual('-n')
      expect(p4args[2]).toEqual('-f')

  describe 'p4edit', ->

    invokeP4Edit = (options) ->
      taskContext = createTaskContext(options)
      tasks.p4edit.apply(taskContext)

    invokeDefault = ->
      options =
        paths: ['path1', 'path2']
      invokeP4Edit(options)

    invokeWithPreview = ->
      options =
        preview: true
        paths: ['path1', 'path2']
      invokeP4Edit(options)

    it 'registers default options', ->
      invokeDefault()
      expect(taskContext.options).toHaveBeenCalledWith({preview: false, paths: []})

    it 'spawns perforce command with expected arguments', ->
      invokeDefault()
      expect(mockGrunt.util.spawn).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      expect(spawnArgs[0].cmd).toEqual('p4')
      p4args = spawnArgs[0].args
      expect(p4args.length).toEqual(3)
      expect(p4args[0]).toEqual('edit')
      expect(p4args[1]).toEqual('path1')
      expect(p4args[2]).toEqual('path2')

    it 'spawns perforce command in preview mode when preview option is true', ->
      invokeWithPreview()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      p4args = spawnArgs[0].args
      expect(p4args.length).toEqual(4)
      expect(p4args[1]).toEqual('-n')

    it 'invokes async callback on completion', ->
      invokeDefault()
      expect(taskContext.async).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      spawnHandler = spawnArgs[1]
      spawnHandler(mockError)
      expect(asyncCallback).toHaveBeenCalledWith(mockError)

  describe 'p4submit', ->

    defaultOptions =
      description: 'Automated submit via Grunt'

    simulatedOptions = null

    invokeP4Submit = (options) ->
      simulatedOptions = options
      taskContext = createTaskContext(simulatedOptions)
      tasks.p4submit.apply(taskContext)

    invokeDefault = ->
      options =
        changelist: '12345'
        description: 'a commit message'
      invokeP4Submit(options)

    it 'registers default options', ->
      invokeDefault()
      expect(taskContext.options).toHaveBeenCalledWith(defaultOptions)

    it 'spawns perforce command with expected arguments', ->
      invokeDefault()
      expect(mockGrunt.util.spawn).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      expect(spawnArgs[0].cmd).toEqual('p4')
      expect(spawnArgs[0].args[0]).toEqual('submit')
      expect(spawnArgs[0].args[1]).toEqual('-d')
      expect(spawnArgs[0].args[2]).toEqual(simulatedOptions.description)
      expect(spawnArgs[0].args[3]).toEqual('-c')
      expect(spawnArgs[0].args[4]).toEqual(simulatedOptions.changelist)

    it 'invokes async callback on completion', ->
      invokeDefault()
      expect(taskContext.async).toHaveBeenCalled()
      spawnArgs = mockGrunt.util.spawn.argsForCall[0]
      spawnHandler = spawnArgs[1]
      spawnHandler(mockError)
      expect(asyncCallback).toHaveBeenCalledWith(mockError)

    it 'does not spawn command if changelist is not provided', ->
      options =
        description: 'a commit message'
      invokeP4Submit(options)
      expect(mockGrunt.util.spawn).not.toHaveBeenCalled()
