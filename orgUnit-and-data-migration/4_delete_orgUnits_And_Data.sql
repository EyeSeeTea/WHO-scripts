-------------------- DELETE ORGUNITS --------------------------------------------

-- selects all descendants in an orgUnit
CREATE VIEW orgUnitsToDelete AS
select organisationunitid from organisationunit where path like '%OLD_COUNTRY_ID%' and uid <> 'OLD_COUNTRY_ID';


-- Delete related data (that may not be needed since all data should be migrated, except if we want to delete data)

delete   from trackedentitydatavalue where programstageinstanceid in (select programstageinstanceid from  programstageinstance where organisationunitid in (select * from orgUnitsToDelete));
delete   from trackedentitydatavalueaudit where programstageinstanceid in (select programstageinstanceid from  programstageinstance where organisationunitid in (select * from orgUnitsToDelete));
delete   from programstageinstancecomments where programstageinstanceid in (select programstageinstanceid from  programstageinstance where organisationunitid in (select * from orgUnitsToDelete));
delete   from programstageinstance where organisationunitid in (select * from orgUnitsToDelete);
delete  from trackedentityattributevalue where trackedentityinstanceid in (select trackedentityinstanceid from  trackedentityinstance where organisationunitid in (select * from orgUnitsToDelete));
delete  from trackedentityattributevalueaudit where trackedentityinstanceid in (select trackedentityinstanceid from  trackedentityinstance where organisationunitid in (select * from orgUnitsToDelete));


-- Delete relations

delete from datasetsource where sourceid in (select * from orgUnitsToDelete);
delete from orgunitgroupmembers where organisationunitid in (select * from orgUnitsToDelete);
delete from program_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete from programstageinstance where organisationunitid in (select * from orgUnitsToDelete);

delete  from  _orgunitstructure where organisationunitid in (select * from orgUnitsToDelete);
delete  from  _datasetorganisationunitcategory where organisationunitid in (select * from orgUnitsToDelete);
delete  from  _organisationunitgroupsetstructure where organisationunitid in (select * from orgUnitsToDelete);
delete  from  datavalueaudit where organisationunitid in (select * from orgUnitsToDelete);
delete  from  categoryoption_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  chart_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  dataapproval where organisationunitid in (select * from orgUnitsToDelete);
delete  from  dataapprovalaudit where organisationunitid in (select * from orgUnitsToDelete);
delete  from  eventchart_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  eventreport_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  interpretation where organisationunitid in (select * from orgUnitsToDelete);
delete  from  lockexception where organisationunitid in (select * from orgUnitsToDelete);
delete  from  mapview_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  organisationunitattributevalues where organisationunitid in (select * from orgUnitsToDelete);
delete  from  organisationunittranslations where organisationunitid in (select * from orgUnitsToDelete);
delete  from  orgunitgroupmembers where organisationunitid in (select * from orgUnitsToDelete);
delete  from  program_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  programinstance where organisationunitid in (select * from orgUnitsToDelete);
delete  from  programmessage where organisationunitid in (select * from orgUnitsToDelete);
delete  from  programstageinstance where organisationunitid in (select * from orgUnitsToDelete);
delete  from  reporttable_organisationunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  trackedentityinstance where organisationunitid in (select * from orgUnitsToDelete);
delete  from  userdatavieworgunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  usermembership where organisationunitid in (select * from orgUnitsToDelete);
delete  from  userteisearchorgunits where organisationunitid in (select * from orgUnitsToDelete);
delete  from  validationresult where organisationunitid in (select * from orgUnitsToDelete);
delete  from  _view_nhwa_data_audit where organisationunitid in (select * from orgUnitsToDelete);
delete  from  _view_test2 where organisationunitid in (select * from orgUnitsToDelete);
delete  from  datavalue where sourceid in (select * from orgUnitsToDelete);
delete  from completedatasetregistration where sourceid in (select * from orgUnitsToDelete);

delete FROM organisationunit WHERE organisationunitid in (select * from orgUnitsToDelete);

DROP VIEW orgUnitsToDelete;