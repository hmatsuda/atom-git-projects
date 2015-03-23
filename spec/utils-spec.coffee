fs = require 'fs'
path = require 'path'
utils = require '../lib/utils'
Project = require '../lib/models/project'

workspaceElement = null
projects = null
projectsSortedByName = null

describe "Utils", ->

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    waitsForPromise = atom.packages.activatePackage('git-projects')
    projects = [new Project("notification", "", false), new Project("settings-view", "", false), new Project("atom", "", false)]
    projectsSortedByName = [new Project("atom", "", false), new Project("notification", "", false), new Project("settings-view", "", false)]

  describe "sortBy", ->
    it "sorts by name when sortBy == 'Project name'", ->
      atom.config.set('git-projects.sortBy', 'Project name')
      expect(utils.sortBy(projects)).toEqual(projectsSortedByName)

  describe "parsePathString", ->
    it "should be a function",
      expect(utils.parsePathString).toBeFunction

    it "should only take strings in parameter", ->
      wrapper = (any) ->
        return utils.parsePathString.bind this, any

      expect(wrapper "").not.toThrow
      expect(wrapper 1).toThrow
      expect(wrapper null).toThrow

    it "should return a Set", ->
      expect(utils.parsePathString("")).toEqual(new Set)
      expect(utils.parsePathString("path").size).toBe(1)
      expect(utils.parsePathString("path; another_path").size).toBe(2)
      expect(utils.parsePathString("same_path; same_path").size).toBe(1)
