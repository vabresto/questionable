template tryImport(module) = import module

when compiles tryImport pkg/result:
  import pkg/result/../results
elif compiles tryImport pkg/results:
  import pkg/results/../results
else:
  import pkg/stew/results

export results
