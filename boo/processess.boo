procs = System.Diagnostics.Process.GetProcesses()
for proc in procs:
  print proc.Id + " " + proc.MainModule.ModuleName
