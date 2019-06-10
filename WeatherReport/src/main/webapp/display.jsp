<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<style>
 tr, th, td {
   border : 1px solid black;
   table-layout: auto;
   width: 180px;
 }
 
 table {
        display: block;
        max-width: 100%;
        overflow: scroll; <!-- Available options: visible, hidden, scroll, auto -->
    }
 
 select {
  width: 100px
 }
 #error {
  color: red;
 }
</style>
</head>
<body>
  
  <div id="userinput">
	  <label>City</label>
	  <input id="city" type="text"></input>
	  <label>Language</label> 
	  <select id=langcode></select>
	  <label>Temperature</label>
	  <select id=temprule>
	       <option value="0">All</option>
	  	   <option value="1">equals</option>
	  	   <option value="2">greater than</option>
	  	   <option value="3">lesser than</option>
	  </select>
	  <select id=tempvalue>
	  	   <option value="10">10</option>
	  	   <option value="15">15</option>
	  	   <option value="20">20</option>
	  	   <option value="25">25</option>
	  	   <option value="30">30</option>
	  	   <option value="35">35</option>
	  	   <option value="40">40</option>
	  </select>
  </div>
  <input id="submit" type="button" value="Submit"></input><br>
  <label id="error"></label><br>
  <div id="citiesdiv"></div>
  <div id="weatherdiv"></div>
  
  <script>

      $(document).ready(function(){
          loadLangauages();
    	  loadCities();
    	  
    	  $(document).on('click', '.cityclass', function() {
              var selcity = $(this).attr('id');
              var langcode = $("#langcode").val();
              $("#city").val(selcity);
        	   populateWhetherData(selcity, langcode, tempRule);
          });
          
          $("#submit").click(function() {
        	  var selcity = $("#city").val();
        	  var langcode = $("#langcode").val();
        	  $("#error").html("");
        	  populateWhetherData(selcity, langcode, tempRule);
        	  
           });

          $("#langcode").change(function() {
        	  var selcity = $("#city").val();
        	  var langcode = $("#langcode").val();
        	  $("#weatherdiv").empty();
           });
          $("#tempvalue").hide();
          $("#temprule").change(function() {
        	  var ruleval = $("#temprule").val();
        	  showhideutil($("#tempvalue"), (ruleval == "0"))
        	  $("#weatherdiv").empty();
           });
          
          $("#tempvalue").change(function() {
        	  var selcity = $("#city").val();
        	  var langcode = $("#langcode").val();
        	  $("#weatherdiv").empty();
           });
      });
      
     

      /*
       Loads cities from the rest api and populates
     */
      function loadCities() {
    	  $.getJSON("/WeatherReport/loadCities", function(data) {
        	  var cities = [];
        	   $.each(data, function(key, value){
            		 cities.push("<button id='" +key +"' class='cityclass'> " + key +"</button>")
               });
        	   $("<div>",{html: cities.join( "" )}).appendTo( $("#citiesdiv") );
        	   
             }).fail(function(x, y, error) {
          	    console.log("error" + error);
             });
        }


      /*
       Loads languages and language codes from rest api
      */
      function loadLangauages() {
    	  $.getJSON("/WeatherReport/loadLanguages", function(data) {
        	  var languages = [];
        	   $.each(data, function(key, value){
        		   $("#langcode").append($("<option value='"+value+"'/>").text(key));
               });
             }).fail(function(x, y, error) {
          	    console.log("error" + error);
             });
        }
      
      /*
        Fetches city whether data from the openwhetehr map and populates the table
      */
      function populateWhetherData(selcity, langcode, tempRule) {

          if (typeof langcode === 'undefined' || langcode === null || langcode == '') {
        	   langcode = 'en';
             }
          
          var url = "http://api.openweathermap.org/data/2.5/forecast?q=" + selcity +"&lang="+ langcode +"&units=metric&appid=e9f48bdd3b4a4bb8a7f075bca68baf34"
          console.log(url);
          $.getJSON(url, function(data) {
        	  applyWhetherDataFilter(data, tempRule);
            }).fail(function(x, y, error) {
            	 $("#error").html("No records have been returned for the city : " + selcity)
            	 console.log("error" + error);
            }).done(function() {
            	     console.log("Done");
            });
        }
      
       /*
         Apply's temperature filter and populates the table
      */
      function applyWhetherDataFilter(data, tempRule) {
    	  var items = [];
    	  if($("table").length == 0) {
    		  items.push("<tr><th> City Name</th> <th> Country Code</th> <th> Temperature </th> <th> Humidity </th> <th> Windspeed </th> <th> Description </th> </tr>")
    	  }
          
           var wdata = data.list;
           var city = data.city.name;
           var countrycode = data.city.country;
           $.each(wdata, function(index, value){
              var temp = value.main.temp;
               var humidity = value.main.humidity;
               var windspeed = value.wind.speed;
               var description = value.weather[0].description;
               
               if(tempRule(temp)) {
            	   items.push("<tr><td>" + city + "</td> <td>" + countrycode + "</td> <td>" + temp + "</td> <td>" + humidity + "</td> <td>" + windspeed + "</td> <td>" + description + "</td> </tr>");   
               }
               
          });
          $("<table>", {class: "trow", html: items.join( "" )}).appendTo( $("#weatherdiv") );
      }
      
      /*
       Utility function to filter temperature values
      */
      function tempRule (intemp) {
    	  var temp = parseInt(intemp);
    	  var rulevalue = $("#temprule").val();
    	  var tempvalue =  parseInt($("#tempvalue").val());
    	  
    	  if(rulevalue == "0") {
    		  return true;
    	  }
    	  switch(rulevalue) {
	    	  case "1":
	    		  return (temp == tempvalue);
	    	  case "2":
	    		  return (temp > tempvalue);
	    	  case "3":
	    		  return (temp < tempvalue);
    	  }
    	  
    	  return true;
      }
      
      /*
       Utility function to hide or show a element
      */
      function showhideutil(element , hide) {
    	  if(hide) {
    		  element.hide();
    	  } else {
    		  element.show();
    	  }
    	  
      }
  </script>
</body>
</html>