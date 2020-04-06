# dhis2togodata
dhis2 to godata organisation unit converter

How to use:
1) Download dhis2 organisation unit files and add the files to the input folder. 
You can add multiple files to convert in the same execution.
2) Run the script (run-dhis2togodata.bat).
3) The files will be generated in the output folder.

How to download dhis2 formatted org units:
To download the dhis2 files is recommended use the following api call: /api/organisationUnits.json?filter=path:ilike:/xB6nQN5Wtpg&fields=name,id,level,coordinates,featureType,code,parent,children[id]&paging=false

Example: https://extranet.who.int/dhis2-dev/api/organisationUnits.json?filter=path:ilike:/xB6nQN5Wtpg&fields=name,id,level,coordinates,featureType,code,parent,children[id]&paging=false
Replacing https://extranet.who.int/dhis2-dev/ by the server and xB6nQN5Wtpg by the country uid and save as json

Requirements:
Python 2.7 
- To install python download the appropriate package from the following link: https://www.python.org/download/releases/2.7/

