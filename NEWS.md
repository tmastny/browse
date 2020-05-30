# browse 0.1.0

* `browse` and `link` now work on any path to a file in a git repo, regardless
  of the current working directory. This makes the functions more flexible,
  especially when used from the command line to navgiate to files in other
  repos. 

* Resolved #6, where the links didn't work if your working 
  directory was not the top level of the git repo

* Improved tests to check the functions work on various file path types,
  and working directories.

# browse 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
