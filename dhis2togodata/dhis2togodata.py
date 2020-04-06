import copy
import os
from os.path import isfile
from os import listdir
from os.path import join
import json
import re
import sys

level_code = "LNG_REFERENCE_DATA_CATEGORY_LOCATION_GEOGRAPHICAL_LEVEL_ADMIN_LEVEL_%s"
file = "config.json"
godata_skell = {"children": "%s",
                "location": {"geoLocation": {"lng": "%s", "lat": "%s"},
                             "identifiers": [{"code": "%s"}],
                             "name": "%s", "active": True,
                             "id": "%s", "populationDensity": 0,
                             "geographicalLevelId": "%s"}}
relations = dict()


def main():
    root_org_unit_uid = ""

    cfg = get_config("config.json")
    default_level = cfg["default_level"]
    input = cfg["input_dir"]
    output = cfg["output_dir"]

    files = [f for f in listdir(input) if isfile(join(input, f))]
    for path_file in files:
        print("generating " + path_file)
        with open(os.path.join(input, path_file), encoding='utf8') as json_file:
            objects = json.load(json_file)

            for orgunit in objects["organisationUnits"]:
                if str(orgunit["level"]) == default_level:
                    root_org_unit_uid = orgunit["id"]
                    break

            godata_orgunits = create_godata_org_unit(root_org_unit_uid, objects, default_level)

            with open(join(output, path_file), 'w') as outfile_json:
                json.dump(godata_orgunits, outfile_json, indent=4, ensure_ascii=False)
                print("Done " + path_file)


def get_config(fname):
    "Return dict with the options read from configuration file"
    print('Reading from config file %s ...' % fname)
    try:
        with open(fname) as f:
            config = json.load(f)
    except (AssertionError, IOError, ValueError) as e:
        sys.exit('Error reading config file %s: %s' % (fname, e))
    return config


def get_latitude(coordinates):
    return re.findall(r"[-]?\d+\.\d+", coordinates)[0]


def get_longitude(coordinates):
    return re.findall(r"[-]?\d+\.\d+", coordinates)[1]


def get_children(geodata_orgunit, active_org_unit, objects, default_level):
    children = geodata_orgunit["children"]
    children_uids = list()
    for uid in active_org_unit["children"]:
        children_uids.append([uid["id"]])
    if len(children_uids) > 0:
        # reverse list
        children_uids = children_uids[::-1]
    else:
        return geodata_orgunit
    for uid in children_uids:
        org_unit = create_godata_org_unit(uid, objects, default_level)
        children.append(org_unit)
    geodata_orgunit["children"] = children
    return geodata_orgunit


def create_godata_org_unit(uid, objects, default_level):
    for org_unit in objects["organisationUnits"]:
        if org_unit["id"] in uid:

            godata_level = org_unit["level"] - int(default_level)
            latitude = ""
            longitude = ""
            if "coordinates" in org_unit.keys() and "featureType" in org_unit.keys() and org_unit[
                "featureType"] == "POINT":
                latitude = get_latitude(org_unit["coordinates"])
                longitude = get_longitude(org_unit["coordinates"])
            uid = org_unit["id"]
            if "code" in org_unit.keys():
                code = org_unit["code"]
            else:
                code = uid
            geodata_orgunit = {"children": [],
                               "location": {"geoLocation": {"lng": latitude, "lat": longitude},
                                            "identifiers": [{"code": code}],
                                            "name": org_unit["name"], "active": True,
                                            "id": uid, "populationDensity": 0,
                                            "geographicalLevelId": (level_code % godata_level)}}

            get_children(geodata_orgunit, org_unit, objects, default_level)
            return geodata_orgunit


if __name__ == '__main__':
    main()
