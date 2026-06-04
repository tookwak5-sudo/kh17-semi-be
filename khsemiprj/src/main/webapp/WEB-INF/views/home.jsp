<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
	<jsp:include page="/WEB-INF/views/template/header.jsp"/>
    
    <style>
   		#calendar {
	        position: relative;
	        z-index: 1;
	    }
    </style>
    
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
    <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/google-calendar@6.1.20/index.global.min.js'></script>
    <script type="text/javascript">
      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
          initialView: 'dayGridMonth',
           googleCalendarApiKey: 'AIzaSyAdaBrCDUIhIqjgduC-zUb3scUngM9hXPM',
           events: {
              googleCalendarId: '0caa26c9579ff8f9de81f1120f2710fdc87b12d2ea24f0c1b62816b83b775bdb@group.calendar.google.com'
           }
        });
        calendar.render();
      });
    </script>
  	<div class="container mt-50 md-50">
    <div id='calendar'></div>
    </div>

    <jsp:include page="/WEB-INF/views/template/footer.jsp"/>