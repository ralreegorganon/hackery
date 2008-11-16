#!/usr/bin/env python
from optparse import OptionParser
import cjson

do_action_def = {
  "Name" : "Bizzle fo shizzle",
  "Description" : "Some pimp shit",
  "Icon" : "text-x-script",
  "SupportedItemTypes" : ["Do.Universe.ITextItem", "Do.Universe.IFileItem" ]
}

def main():                       
  parser = OptionParser()
  parser.add_option("-d", "--do-action-def", action="store_true", default=False)
  (options, args) = parser.parse_args()
	
  if options.do_action_def:
    print_do_action_def()
  else:
    run_with_items(args[0])

def print_do_action_def():
  print cjson.encode(do_action_def)

def run_with_items(json):
  items = cjson.decode(json)
  
  foo = ""

  for item in items:
    if "Text" in item.keys():
      foo = item["Text"]

  return_items = [{ 
    "__type" : "Do.Universe.TextItem",
    "Name" : "Python name",
    "Description" : "Python description",
    "Icon" : "text-x-script",
    "Text" : foo}
  ]
  
  print cjson.encode(return_items)


if __name__ == "__main__":
  main()
