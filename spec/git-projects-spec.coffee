{$} = require 'atom-space-pen-views'
GitProjects = require '../lib/git-projects'
utils = require '../lib/utils'
workspaceElement = null
fs = require 'fs'
path = require 'path'

describe "GitProjects", ->

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    waitsForPromise = atom.packages.activatePackage('git-projects')

  describe "when the git-projects:toggle event is triggered", ->
    it "Shows the view containing the list of projects", ->
      atom.commands.dispatch workspaceElement, 'git-projects:toggle'
      expect($(workspaceElement).find('.git-projects')).toExist()

  describe "findGitRepos", ->
    it "should return an array", ->
      atom.config.set('git-projects.showSubRepos', false)
      expect(GitProjects.findGitRepos()).toEqual([])
      expect(GitProjects.findGitRepos("~/workspace/;~/workspace; ~/workspace/fake", "~/workspace/www", "node_modules;.git")).toBeArray

    it "should work with sub directories", ->
      atom.config.set('git-projects.showSubRepos', true)
      expect(GitProjects.findGitRepos("~/workspace/;~/workspace; ~/workspace/fake", "~/workspace/www", "node_modules;.git")).toBeArray

    it "should not contain any of the ignored patterns", ->
      projects = GitProjects.findGitRepos("~/workspace/;~/workspace; ~/workspace/fake", "~/workspace/www", "node_modules;.git")
      projects.forEach (project) ->
        expect(project.path).not.toMatch( /node_modules|\.git/g )

    it "should not contain any of the ignored paths", ->
      projects = GitProjects.findGitRepos("~/workspace/;~/workspace; ~/workspace/fake", "~/workspace/www", "node_modules;.git")
      projects.forEach (project) ->
        expect(project.path).not.toMatch( /\/workspace\/www/g )
