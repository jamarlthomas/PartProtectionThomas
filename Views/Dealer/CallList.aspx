<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CallList.aspx.vb" Inherits="WIS2.CallList" %>

<%@ Register src="AdminMenu.ascx" tagname="AdminMenu" tagprefix="uc2" %>
<%@ Register src="AdminHeader.ascx" tagname="AdminHeader" tagprefix="uc1" %>
<%@ Register src="ucRequestDetail.ascx" tagname="ucRequestDetail" tagprefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server"> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>WIS Inspections - Admin Home - Assigned</title>
     <!-- jquery-->
    <script src="../Scripts/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="../Scripts/bootstrap.min.js" type="text/javascript"></script>   
    <script src="../Scripts/bootstrap-datetimepicker.min.js" type="text/javascript"></script>  
    <script src="../Scripts/jquery.validate.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.validate.unobtrusive.min.js" type="text/javascript"></script>
    <script src="../Scripts/knockout-3.2.0.js" type="text/javascript"></script>
   <script type="text/javascript" src="../Scripts/sweetalert2.min.js"></script>


    <link href="../Styles/bootstrap-combined.min.css" rel="stylesheet" />
    <link href="../Styles/bootstrap-responsive.min.css" rel="stylesheet" />
    <link href="../Styles/bootstrap-datetimepicker.min.css" rel="stylesheet" /> 

    <link rel="stylesheet" href="../Styles/reset.css" type="text/css" media="screen, projection" />
    <link rel="stylesheet" href="../Styles/style2.css" type="text/css" media="screen, projection" />
    <link rel="stylesheet" href="../Styles/menu.css" type="text/css" media="screen, projection" />    
    <link rel="stylesheet" href="../Styles/dashboard.css" type="text/css" media="screen, projection" />
    <link type="text/css" href="../Styles/sweetalert2.css" rel="stylesheet" />

    <script src="../Scripts/jquery.loadmask.min.js" type="text/javascript"></script>
    <link href="../Styles/jquery.loadmask.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Scripts/adminajax.js"></script>


       
       

   <style type="text/css" >

       .trPending {
           color:blue;
       }

       .trActive {
           color:black;
       }

#tblRequest_filter {
           background-color:white;
       }

 #tblRequest_filter label {
             color:green;
               color:#2B557F;
               font-size:1.3em;
       }

     .ui-state-default {
        background: none;
        background-color:white;
        color:#2B557F;
        font-size:1.3em;
        border:0px none transparent;
        }

     .ui-state-default .ui-icon {
      background-image: url(../Styles/ui-theme/images/ui-icons_222222_256x240.png);
        }

 table.dataTable tr.odd{
            border-top: solid 1px gainsboro;
            border-right: dotted 1px #A6C4E0;
            width: 35px;
            background-color: #e5f8ff;
            text-align: center;
            vertical-align: middle;
            color:black;
            }
 
 table.dataTable tr.even {
            border-top: solid 1px gainsboro;
            border-right: dotted 1px #A6C4E0;
            width: 35px;
            background-color: white;
            text-align: center;
            vertical-align: middle;
            color:black;
            }

 .automatedNotificationTypeBreakdown{
     float:left;
     margin:10px 10px 10px 10px;
    color:black;   
 }

  .timeIntervalTotals{
    text-decoration:underline;
    cursor:pointer;
    float:left;
    font-size:1.3em;
 }
    
  .timeIntervalTotalsHeader{
    float:left;
    font-size:1.3em;
    font-weight:bolder;
    margin-right:5px; 
 }

.divExplanationText{
    font-size:1.3em;
    margin-left:25px;      
    padding-top:5px;
    padding-bottom:5px;
}
</style>

    
    <script type="text/javascript">
        $(document).ready(function () {
            $(function () { $('.datepicker').datetimepicker({ language: 'pt-BR' }); });
    
            var inspectorViewModel = function () {
                var self = this;
                var timer = null;

                self.error = ko.observable();
                self.pageNotification = ko.observable(); //info for page wide actions.
                self.noteFollowUpDateNotification = ko.observable(); //info for modal notifications
                self.inspectors = ko.observableArray(); //inspector list
                self.automatedInspectorNotificationSummary = ko.observable(); //summary data
                self.requests = ko.observableArray(); //request based on inspector id
                self.currentInspectorID = ko.observable(); //current chosen inspector id
                self.currentRequestID = ko.observable(); //current chosen request id
                self.lastChosenRequestID = ko.observable();
                self.note = ko.observable();
                self.inspectorToFind = ko.observable();
                self.alphabetizedInspectors = ko.observableArray();
                self.automatedInspectorNotificationFilterID = ko.observable(); //filters inspectors by the metric in question - if the inspector has other elements in other request, they'll still show
                self.callListTimeIntervalFilterID = ko.observable();
               
                function ajaxHelper(uri, data) {
                    self.error(''); // Clear error message
                    return $.ajax({
                        type: "POST",
                        url: uri,
                        dataType: 'json',
                        contentType: "application/json; charset=utf-8",
                        data: data,
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        self.error(errorThrown);
                    });
                }

                function refreshCallList()
                {
                    getInspectorsOnCallList();
                    setAlphabetizeInspectorsList();
                    getAutomatedInspectorNotificationSummary();
                  
                    if (parseInt(self.currentInspectorID()) <= 0)
                    {
                        return;
                    }

                    getAutomatedNotificationRequestsByInspector(self.currentInspectorID());
                    //window.alert("UPDATE COMPLETE");
                }

                function getAutomatedNotificationRequestsByInspector(inspectorID)
                {
                    var url = "../RequestWebService.asmx/GetAutomatedNotifcationRequest";
                    var data = { "inspectorID": inspectorID };
                    var jsonData = JSON.stringify(data);

                    ajaxHelper(url, jsonData).done(function (response) {
                        self.requests(response.d);
                        self.currentInspectorID(inspectorID);
                        $(".request_detail").hide();
                        $("#trRequests_" + inspectorID).fadeIn();
                        //console.log(response.d);
                    });
                }

                function getAutomatedInspectorNotificationSummary()
                {
                    var url = "../RequestWebService.asmx/GetAutomatedInspectorNotificationSummary";
                    ajaxHelper(url, null).done(function (response) {
                        self.automatedInspectorNotificationSummary(response.d);
                        //    console.log(response.d);
                    });
                }

                function getInspectorsOnCallList() {
                    var url = "../RequestWebService.asmx/GetInspectorsOnCallList";
                    var data = { "automatedInspectorNotificationTypeID": self.automatedInspectorNotificationFilterID(),"callListTimeIntervalTypeID":self.callListTimeIntervalFilterID() };
                    var jsonData = JSON.stringify(data);

                    ajaxHelper(url, jsonData).done(function (response) {
                        self.inspectors(response.d);
                        setAlphabetizeInspectorsList();
                        
                    //    console.log(response.d);
                    });
                }

                // Fetch the initial data.

                function setNoteFollowUpDateNotification(isSuccess, msg)
                {
                    if (msg == null || msg == "") {
                        self.noteFollowUpDateNotification("");
                        ("#divNoteFollowUpDateModalNotification").hide();
                        return;
                    }

                    if (isSuccess == true) {$("#divNoteFollowUpDateModalNotification").css("color","green"); }
                    else{$("#divNoteFollowUpDateModalNotification").css("color","red"); }
                    self.noteFollowUpDateNotification(msg);
                    $("#divNoteFollowUpDateModalNotification").show();

                    //close after 5 seconds
                    setTimeout(endNotifications, 5000);
                }


                function notify(isSuccess, msg) {
                    if (msg == null || msg == "") {
                        self.pageNotification("");
                        ("#divPageNotification").hide();
                        return;
                    }

                    if (isSuccess == true) { $("#divPageNotification").css("color", "green"); }
                    else { $("#divPageNotification").css("color", "red"); }
                    self.pageNotification(msg);
                    $("#divPageNotification").show();

                    //Close after 5 seconds
                    setTimeout(endNotifications, 5000);
                }

                function endNotifications()
                {
                    notify(false,null);
                    setNoteFollowUpDateNotification(false, null);
                }

                function setAlphabetizeInspectorsList()
                {
                    self.alphabetizedInspectors(self.inspectors().sort(function (a, b) { return a.InspectorName > b.InspectorName ? 1 : -1; }));
                }

                function getExplanationByNotificationType(notificationTypeID)
                {
                    var header = "";
                    var titleBlurb = "";

                    switch (notificationTypeID)
                    {
                        case 5:
                            header = "ETA In Advance of RTI Date!";
                            titleBlurb = "ETA exceeds RTI date by 24hrs.";
                            break;
                        case 4:
                            header = "Follow Up Date Has Been Exceeded!";
                            titleBlurb = "Follow Up Date has been passed.";
                            break;
                        case 7:
                            header = "Request is on Hotlist!";
                            titleBlurb = "Any item on assigning, late reports or picture's hot list, belongs on the call list. ";
                            break;
                        case 2:
                            header = "Need Update - ETA Passed!";
                            titleBlurb = "Inspector has gone several hours over their estimated inspection datetime without reporting back.";
                            break;
                        case 1:
                            header = "ETA Missing!";
                            titleBlurb = "Inspector has not provided an inspection time.";
                            break;                          
                        case 3:
                            header = "Assignment Not Confirmed!";
                            titleBlurb = "Request has not been marked assingment confirmed.";
                            break;
                        case 6:
                            header = "Verbal Missing!";
                            titleBlurb = "Inspection completed but verbal hasn't been completed within 3 hours.";
                            break;
                            default:
                                break;                   
                    }

                    //erase previous information
                    $(".divExplanation").hide();
                    $('#hdrCallListMetricExplanationTitle').empty();
                    $("#divMetricExplanationBlurb").empty();

                    //add new information based on inspection type id
                    $('#hdrCallListMetricExplanationTitle').html(header);
                    $("#divMetricExplanationBlurb").html(titleBlurb);
                    $("#divExplanation" + notificationTypeID).show();

                    //open modal
                    $('#divCallListMetricExplanationHelper').modal('show');
                }


                self.getAutomatedNotifcationRequest = function (item) {
                    getAutomatedNotificationRequestsByInspector(item.InspectorID);
                    //var url = "../RequestWebService.asmx/GetAutomatedNotifcationRequest";
                    //var data = { "inspectorID": item.InspectorID };
                    //var jsonData = JSON.stringify(data);

                    //ajaxHelper(url, jsonData).done(function (response) {
                    //    self.requests(response.d);
                    //    self.currentInspectorID(item.inspectorID);
                    //    $(".request_detail").hide();
                    //    $("#trRequests_" + item.InspectorID).fadeIn();
                    //    //console.log(response.d);

                    //});
                };

                self.getRequestDetail = function (item) {
                   
                    if (parseInt(item.RequestID) == parseInt(self.currentRequestID()))
                    {//no change
                        return;
                    }

                    self.currentRequestID(item.RequestID);

                    $("#btnAddNote").hide();
                    var id = item.RequestID;
                    var zip = item.Zip;

                    //IsHighInspectionFeeReached(id);
                    GetNotes(id);
                    GetStatus(id);
                    GetInspectors(zip, id);
                    GetInspectorsB(zip, id);
                    GetConcerns(id);
                    GetRequestData(id);                                                                
                };


                self.openNoteFollowUpDateModal = function (item) {
                    self.currentInspectorID(item.InspectorID);
                    $('#hdrNoteFollowUpDateModal').empty();
                    $('#hdrNoteFollowUpDateModal').html("Inspector: " + item.InspectorName);
                    $('#divNoteFollowUpDateModal').modal('show');
                };
           
                self.cancleNoteFollowModal = function () {
                    self.note("");
                    $('#txtDatePicker').val("");
                };

                self.submitNoteFollowUpDateToAllRequest = function () {
                    var url = "../RequestWebService.asmx/SubmitNoteFollowUpDateToAllRequest";
                    var followUpDate = $('#txtDatePicker').val();

                    var data = {"inspectorID":self.currentInspectorID(), "followUpDate":followUpDate,"note":self.note()};
                    var jsonData = JSON.stringify(data);

                    ajaxHelper(url, jsonData).done(function (response) {
                        var returnMsg = response.d;
                        if (returnMsg == "SUCCESS")
                        {
                            notify(true, "Requests Successfully Updated")
                            $('#divNoteFollowUpDateModal').modal('hide');
                        }
                        else {
                            setNoteFollowUpDateNotification(false, returnMsg);
                        }
                    });
                
                };

                self.clearAllFollowUpDates = function (item) {

                    var url = "../RequestWebService.asmx/ClearFollowUpDateToAllRequest";
                    
                    var data = { "inspectorID": item.InspectorID };
                    var jsonData = JSON.stringify(data);

                    ajaxHelper(url, jsonData).done(function (response) {
                        //window.alert(response.d);
                        var returnMsg = response.d;
                        if (returnMsg == "SUCCESS") {
                            notify(true, "Requests Successfully Updated")                           
                        }
                        else {
                            setNoteFollowUpDateNotification(false, returnMsg);
                        }
                    });
                };

                self.findInspectorByName = function (item)
                {
                    getAutomatedNotificationRequestsByInspector($("#ddlInspectorToFind").val());                   
                };

                self.getCssClassByStatusType = function (item) {
                    if (item.StatusTypeID == 1)
                    { return "trPending"; }
                    else
                    { return "trActive"; }
                };

         
                self.getExplanationOfInsNotificationTypeID5 = function () { getExplanationByNotificationType(5); };
                self.getExplanationOfInsNotificationTypeID4 = function () { getExplanationByNotificationType(4); };
                self.getExplanationOfInsNotificationTypeID7 = function () { getExplanationByNotificationType(7); };
                self.getExplanationOfInsNotificationTypeID2 = function () { getExplanationByNotificationType(2); };
                self.getExplanationOfInsNotificationTypeID1 = function () { getExplanationByNotificationType(1); };
                self.getExplanationOfInsNotificationTypeID3 = function () { getExplanationByNotificationType(3); };
                self.getExplanationOfInsNotificationTypeID6 = function () { getExplanationByNotificationType(6); };

                self.filterID5 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(5); refreshCallList(); };
                self.filterID4 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(4); refreshCallList(); };
                self.filterID7 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(7); refreshCallList(); };
                self.filterID2 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(2); refreshCallList(); };
                self.filterID1 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(1); refreshCallList(); };
                self.filterID3 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(3); refreshCallList(); };
                self.filterID6 = function (item) { self.callListTimeIntervalFilterID(0); self.automatedInspectorNotificationFilterID(6); refreshCallList(); };
                self.timeIntervalFilterID1 = function (item) { self.automatedInspectorNotificationFilterID(0); self.callListTimeIntervalFilterID(1); refreshCallList(); };
                self.timeIntervalFilterID2 = function (item) { self.automatedInspectorNotificationFilterID(0); self.callListTimeIntervalFilterID(2); refreshCallList(); };
                self.timeIntervalFilterID3 = function (item) { self.automatedInspectorNotificationFilterID(0); self.callListTimeIntervalFilterID(3); refreshCallList(); };
                self.clearFilter = function (item) { self.automatedInspectorNotificationFilterID(0); self.callListTimeIntervalFilterID(0); refreshCallList(); };

                self.automatedInspectorNotificationFilterID(0);
                self.callListTimeIntervalFilterID(0);
                getAutomatedInspectorNotificationSummary();
                getInspectorsOnCallList();
                self.currentInspectorID(0);
                timer = setInterval(refreshCallList, 150000);

            };

            ko.applyBindings(new inspectorViewModel());



        });

       
    </script>

</head>

<body>
<form id="Form1" runat="server">
     <asp:ScriptManager EnablePageMethods="true" ID="ScriptManager1" runat="server"></asp:ScriptManager> 
    <uc1:AdminHeader ID="AdminHeader1" runat="server" />

    <div class="dash">

    <ul id="tabnav">
	    <li class="tab"><a href="Unassigned.aspx">Unassigned</a></li>
	    <li class="tab"><a href="Assigned.aspx">Assigned</a></li>
	    <li class="tab"><a href="InProgress.aspx">In Progress</a></li>
	    <li class="tab"><a href="TBR.aspx">To Be Reviewed</a></li>
        <li class="tab"><a href="Late.aspx">Late</a></li> 
        <li class="tab"><a href="Hot.aspx">Hot</a></li>
        <li class="tab"><a href="Hold.aspx">Hold</a></li>
	    <li class="tab"><a href="Search.aspx">Find</a></li>
        <li class="tab selected"><a href="CallList.aspx"><span id="selectedtab">Call List</span></a></li>
    </ul>

    <div style="clear:both;height:10px;"></div>
        <div id="divPageNotification" style="font-weight:bolder;width:100%;text-align:center;font-size:1.4em;display:none;height:25px;margin-bottom:5px;" data-bind="text:pageNotification"></div>

        <div data-bind="with:automatedInspectorNotificationSummary" style="height:auto;width:850px;text-align:left;margin-bottom:15px;">

            <div style="margin-top:10px;margin-left:50px;margin-bottom:10px;">
                   <div style="float:left;height:auto;font-size:1.3em;font-weight:bolder;padding-top:10px;margin-right:10px;">Filter By Inspector</div>
                    <div style="float:left;height:auto;font-size:1.3em;margin-right:10px;">
                            <select id="ddlInspectorToFind" data-bind="options: $root.alphabetizedInspectors, optionsText: 'InspectorName', optionsValue: 'InspectorID', event: { change: $root.findInspectorByName }"></select>
                    </div>
                
            </div>

            <div style="height:5px;clear:both;"></div>
            <div style="margin-left:60px;font-size:1.1em;height:auto;">
                <div style="float:left;width:125px;font-weight:bolder;font-size:1.2em;">Request Totals:</div>
                 
                <div class="timeIntervalTotalsHeader"  style="">Total:</div>
                <div class="timeIntervalTotals" style="color:black;" data-bind="text: TotalNotifications,click:$root.clearFilter"></div>
                
                <div style="float:left;margin-left:10px;margin-right:10px;">|</div>

                 <div class="timeIntervalTotalsHeader">3hrs or Less:</div>
                 <div class="timeIntervalTotals"  style="color:darkgreen;" data-bind="text: ThreeHoursOrLessCount, click: $root.timeIntervalFilterID1"></div>
                               
                <div style="float:left;margin-left:10px;margin-right:10px;">|</div>

                  <div class="timeIntervalTotalsHeader">3hrs to 6hrs:</div>
                  <div class="timeIntervalTotals" style="color:#b08606;" data-bind="text: ThreeToSixHoursCount, click: $root.timeIntervalFilterID2"></div>
                
                    <div style="float:left;margin-left:10px;margin-right:10px;">|</div>

                  <div class="timeIntervalTotalsHeader">6hrs or Greater:</div>
                 <div  class="timeIntervalTotals"  style="color:darkred;" data-bind="text: SixOrMoreHoursCount, click: $root.timeIntervalFilterID3"></div>
                               
  
                <div style="clear:both;"></div>
                    <div style="height:auto;width:850px;">
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID5">ETA Exceeds RTI:</span> <a style="padding-left:3px;padding-right:3px;font-weight:bolder;" href="#" data-bind="    click: $root.filterID5, text: ETAExceedsReadyToInspect"></a></div>    
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID4">Follow Up Exceeded:</span> <a style="padding-left:3px;padding-right:3px;font-weight:bolder;" href="#" data-bind="    click: $root.filterID4, text: FollowUpDateExceeded"></a></div>    
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID7">HotList:</span> <a style="padding-left:3px;padding-right:3px;font-weight:bolder;"  href="#" data-bind="    click: $root.filterID7, text: HotList"></a></div>    
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID2">Exceeds ETA:</span> <a  style="padding-left:3px;padding-right:3px;font-weight:bolder;" href="#" data-bind="    click: $root.filterID2, text: InspectionSeveralHoursBeyondETA"></a></div>    
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID1">Missing Time:</span> <a style="padding-left:3px;padding-right:3px;font-weight:bolder;"  href="#" data-bind="    click: $root.filterID1, text: MissingTimeOfInspection"></a></div>    
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID3">Assigned Not Confirmed:</span> <a style="padding-left:3px;padding-right:3px;font-weight:bolder;" href="#" data-bind="    click: $root.filterID3, text: RequestAssignedButNotConfirmed"></a></div>    
                        <div class="automatedNotificationTypeBreakdown" style=""><span style="cursor:pointer;" data-bind="click: $root.getExplanationOfInsNotificationTypeID6">Verbal Missing:</span> <a href="#" style="padding-left:3px;padding-right:3px;font-weight:bolder;"  data-bind="    click: $root.filterID6, text: VerbalReportMissing"></a></div>    
                 </div>                
            </div>
        </div>

        <div style="width:100%;text-align:center;margin-left:50px;"><hr style="width:65%;" /></div>
          <div id="divInspectorList" class="container" style="margin-left:5px;">
    

              <div class="panel-body" style="float:left;width:1000px;height:auto;height:300px;overflow-y:scroll;">
                <table style="margin-left:5px;width:850px;" cellpadding="5" cellspacing="5">
                    <thead>
                        <tr>
                            <th style="text-align:center;font-size:1.2em;">Inspector Name</th>
                            <th style="text-align:center;font-size:1.2em;">Cell</th>
                            <th style="text-align:center;font-size:1.2em;">City & State</th>
                            <th style="text-align:center;font-size:1.2em;">Actions<small>(All Inspector Request)</small></th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach:inspectors">
                        <tr style="">
                            <td style="text-align:center;"><div style="font-size:1.2em;margin-top:15px;"><a href="#" data-bind="click: $parent.getAutomatedNotifcationRequest, text: InspectorName"></a><span data-bind="text: '(' + NumberOfRequestForInspector + ')'"></span> </div></td>
                            <td style="text-align:center;"> 
                                        <div style="font-size:1.2em;height:auto;margin-top:15px;" data-bind="text: InspectorCellNumber"></div>
                            </td>
                            <td style="text-align:center;"><div  style="font-size:1.2em;height:auto;margin-top:15px;" data-bind="text: City + ',' + State"></div></td>
                            <td style="text-align:center;"> 
                                <div style="height:auto;width:400px;margin-top:15px;font-size:1.2em;">
                                    <a href="#divAddNoteModal" data-bind="click: $parent.openNoteFollowUpDateModal" >Add Note / Follow Up </a> &nbsp; &nbsp;
                                    <a href="#" data-bind="click: $parent.clearAllFollowUpDates" >Clear Follow Up</a> &nbsp; &nbsp;                                 
                                </div>                                
                            </td>                                                    
                        </tr>
                        <tr data-bind="attr: {id:'trRequests_' + InspectorID}" class="request_detail" style="display:none;">
                            <td style="width:100%;" align="left" valign="middle" colspan="4">
                                <div style="height:10px;"></div>
                                   <table style="margin-left:60px;width:auto;" cellpadding="" cellspacing="5">
                                        <thead>
                                        <tr>
                                            <th style="text-align:center;font-size:1em;">RequestID</th>
                                            <th style="text-align:center;font-size:1em;">Date </th>
                                            <th style="text-align:center;font-size:1em;">Customer Name</th>
                                            <th style="text-align:center;font-size:1em;">Issue Description</th>
                                            <th style="text-align:center;font-size:1em;">Last Updated</th>
                                        </tr>
                                    </thead>
                                        <tbody data-bind="foreach: $parent.requests">
                                           <tr data-bind="attr: { class: $root.getCssClassByStatusType($data) }" >
                                                <td style="text-align:center;"><div style="width:75px;margin-top:8px;" ><a href="#" data-bind="click: $root.getRequestDetail, text: RequestID"></a></div></td>
                                                <td style="text-align:center;"><div style="width:100px;margin-top:8px;" data-bind="text: RequestDate"></div></td>
                                                <td style="text-align:center;"><div style="width:200px;margin-top:8px;" data-bind="text: CustomerName"></div></td>
                                                <td style="text-align:left;"><div style="margin-top:8px;width:250px;" data-bind="text: Description"></div></td>                             
                                                <td style="text-align:center;"><div style="margin-top:8px;width:110px;" data-bind="text: LastActivity + ' by ' + LastActivityEnteredBy"></div></td>  
                                           </tr>
                                       </tbody>
                                       </table>
                                <hr color="#000080" style="margin-left:20%;width:75%;text-align:center;height:1px;" />
                            </td>
                        </tr>
                    </tbody>
                </table>
             </div>
        </div>

        <!--begin details area-->
        <uc3:ucRequestDetail ID="ucRequestDetail1" ClientIDMode="Static" runat="server" />
        <!--end details area-->
   </div>




    <!--MODALS START -->

    <div id="divNoteFollowUpDateModal" style="display:none;width:500px;overflow:hidden;" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="hdrNoteFollowUpDateModal" aria-hidden="true">
     <div id="divNoteFollowUpDateModalNotification" data-bind="text: noteFollowUpDateNotification" style="font-size:1.4em;margin-bottom:10px;color:green;margin-top:10px;width:100%;text-align:center;font-weight:bolder;display:none;"></div>
           <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"  data-bind="click: cancleNoteFollowModal"  aria-hidden="true">×</button>
            <h3 id="hdrNoteFollowUpDateModal" class=""></h3>
        </div>

        <div class="modal-body">
            <h4 style="width:150px;">Add Note:</h4>
               <textarea class="form-control" style="width:400px;height:100px;" data-bind="value: note" id="txtNewInspectorNote"></textarea>
            
            <div style="clear:both;height:20px;"></div>
            <h4 style="width:150px;">Add Follow Up Date:</h4>
              <div id="divDatePicker" class="datepicker input-append date" style="margin-left:37px;width:auto"><input id="txtDatePicker" data-format="MM/dd/yyyy hh:mm:ss" type="text" style="margin-top:0px;width:200px;"></input><span class="add-on" style=""><i style="" data-time-icon="icon-time" data-date-icon="icon-calendar"></i></span></div>
           
        </div>
        <div class="modal-footer">
            <button class="btn" id="btnCloseNoteFollowUpDateModal" data-bind="click:cancleNoteFollowModal" data-dismiss="modal" aria-hidden="true">Cancel</button>
            <button id="btnSubmitNoteFollowUpDateModal" data-bind="click:submitNoteFollowUpDateToAllRequest" class="btn btn-danger">Submit</button>
        </div>
         
</div>   
      

    
    <div id="divCallListMetricExplanationHelper" style="display:none;width:500px;overflow:hidden;" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="hdrCallListMetricExplanationTitle" aria-hidden="true">
     <div id="" style="font-size:1.4em;margin-bottom:10px;color:green;margin-top:10px;width:100%;text-align:center;font-weight:bolder;display:none;"></div>
           <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3 id="hdrCallListMetricExplanationTitle" class="" style="color:maroon;"></h3>
               <div style="clear:both;height:8px;"></div>
               <div id="divMetricExplanationBlurb" style="font-size:1.4em;margin-left:15px;"></div>
        </div>
        <div class="modal-body">
                <div id="divExplanationMsg">
                    <div style="font-weight:bolder;font-size:1.3em;margin-left:15px;">Protocols Checked:</div>
                    <div style="height:10px;clear:both;"></div>
                
                    <div class="divExplanation" id="divExplanation4">
                        <div class="divExplanationText" >Request is not cancelled. </div>
                        <div class="divExplanationText" >Inspected Date has not been updated. </div>
                        <div class="divExplanationText" >Verbal has not been uploaded. </div>  
                        <div class="divExplanationText" >Report has not been entered </div>  
                        <div class="divExplanationText" >Follow Up Date/Time has passed.</div>       
                        <div style="clear:both;"></div>
                        <div  class="divExplanationText" style="text-decoration:underline;"><b>Process Interval:</b> Every Hour From 7AM - 11PM</div>         
                    </div>
                  
                    <div class="divExplanation"  id="divExplanation7">
                        <div  class="divExplanationText"  >Request is not cancelled. </div>
                        <div  class="divExplanationText"  >Inspected Date has not been updated.</div>
                        <div  class="divExplanationText"  >Follow Up Date/Time has not been set.</div>   
                        <div  class="divExplanationText"  >A 1 hour grace period has passed with the request on the hotlist under category of <i>Assigning</i>, <i>Late Reports</i> or <i>Pictures</i>.</div>  
                        <div style="clear:both;height:8px;"></div>
                        <div  class="divExplanationText" style="text-decoration:underline;margin-top:10px;" ><b>Process Interval:</b> Every 5 Minutes From 7AM - 11PM</div>                                      
                    </div>  
                    
                     <div class="divExplanation"  id="divExplanation2">
                        <div class="divExplanationText" >Request is not cancelled. </div>
                        <div class="divExplanationText" >Inspected date has not been updated.  </div>
                        <div class="divExplanationText" >Follow Up Date/Time has not been set.</div>
                        <div class="divExplanationText" >Verbal has not been uploaded. </div>  
                        <div class="divExplanationText" >Report has not been entered </div>  
                        <div class="divExplanationText" >RTI date is <i>GREATER THAN</i> current date.</div>
                        <div class="divExplanationText" >3 hours <i>GREATER THAN</i> estimated time of inspection without inspection actual date being set.</div>    
                        <div class="divExplanationText" >3 hours <i>GREATER THAN</i> estimated date without verbal being called in or inspected date updated.</div>        
                        <div style="clear:both;height:8px;"></div>
                        <div class="divExplanationText" style="text-decoration:underline;" ><b>Process Interval:</b> Every Hour From 7AM - 11PM</div> 
                    </div>
                    
                        <div class="divExplanation"  id="divExplanation1">
                        <div  class="divExplanationText"  >Request is not cancelled. </div>
                        <div  class="divExplanationText"  >Inspected Date has not been updated.  </div>
                        <div  class="divExplanationText"  >Follow Up Date/Time has not been set.</div>
                        <div  class="divExplanationText"  >Assignment confirmed.</div>  
                         <div  class="divExplanationText"  >RTI date is less than or equal to the current date.</div>
                        <div  class="divExplanationText"  >ETA missing. </div>    
                        <div style="clear:both;height:8px;"></div>
                        <div  class="divExplanationText" style="text-decoration:underline;" ><b> Process Interval:</b> Every Day at 9AM and 12PM</div>                                        
                    </div>
                    
                  <div class="divExplanation"  id="divExplanation3">
                        <div  class="divExplanationText"  >Request is not cancelled. </div>
                        <div  class="divExplanationText"  >Inspected Date has not been updated.  </div>                       
                        <div  class="divExplanationText"  >Follow Up Date/Time has not been set.</div>
                        <div  class="divExplanationText"  >ETA has not been set.</div>
                        <div  class="divExplanationText"  >1 hour has passed without request being marked <i>Assignment Confirmed</i>.</div>    
                        <div style="clear:both;height:8px;"></div>
                        <div  class="divExplanationText" ><b>Process Interval:</b> Every Hour From 7AM - 11PM</div>          
                    </div>
                  
                   <div class="divExplanation"  id="divExplanation6">
                        <div  class="divExplanationText" >Request is not cancelled. </div>
                        <div  class="divExplanationText"  >Follow Up Date/Time has not been set.</div>
                        <div  class="divExplanationText" >Inspected Date has been updated, BUT verbal was not received within 3 hour grace period.</div>
                        <div class="divExplanationText" >Verbal has not been uploaded. </div>  
                        <div class="divExplanationText" >Report has not been entered </div>  
                        <div style="clear:both;height:8px;"></div>
                        <div  class="divExplanationText" style="text-decoration:underline;" ><b>Process Interval:</b> Every 2 Hours From 7AM - 11PM</div>                 
                  </div>

                        <div class="divExplanation"  id="divExplanation5" style="">
                                <div  class="divExplanationText" >Request is not cancelled.</div>
                                <div  class="divExplanationText" >Inspected Date has not been updated. </div>
                                <div  class="divExplanationText"> Follow Up Date/Time has not been set.</div>
                                <div class="divExplanationText" > Verbal has not been uploaded. </div>  
                                <div class="divExplanationText" > Report has not been entered </div>  
                                <div  class="divExplanationText" >ETA exceeds RTI by 24hrs.</div>     
                                <div style="clear:both;height:8px;"></div>
                        <div  class="divExplanationText" style="text-decoration:underline;" ><b>Interval:</b> Every 5 Min From 7AM - 11PM</div>        
                    </div>  
                    
                </div>
        </div>
        <div class="modal-footer">        
        </div>
         
</div>  
    <!--MODALS STOP -->
   
</form>              
</body>
</html>

