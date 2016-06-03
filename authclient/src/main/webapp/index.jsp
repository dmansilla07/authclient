<%@page session="false"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>

<title>Outlook Authentication</title>

<c:url var="home" value="/" scope="request" />

<spring:url value="/resources/core/css/hello.css" var="coreCss" />
<spring:url value="/resources/core/css/bootstrap.min.css"
	var="bootstrapCss" />
<link href="${bootstrapCss}" rel="stylesheet" />
<link href="${coreCss}" rel="stylesheet" />

<spring:url value="/resources/core/js/jquery.1.10.2.min.js"
	var="jqueryJs" />
<script src="${jqueryJs}"></script>
</head>

<nav class="navbar navbar-inverse">
	<div class="container">
		<div class="navbar-header">
			<a class="navbar-brand" href="#">Spring Outlook Authentication</a>
		</div>
	</div>
</nav>

<div class="container" style="min-height: 500px">

	<div class="starter-template">
		<h1>Search Form</h1>
		<br>

		<div id="feedback"></div>

		<form class="form-horizontal" id="search-form">
			<div class="form-group form-group-lg">
				<label class="col-sm-2 control-label">Username</label>
				<div class="col-sm-10">
					<input type=text class="form-control" id="username">
				</div>
			</div>
			<div class="form-group form-group-lg">
				<label class="col-sm-2 control-label">Email</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="email">
				</div>
			</div>

			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<button type="submit" id="bth-search"
						class="btn btn-primary btn-lg">Simple Login</button>
						
					<button type="button" id="bth-outlook"
						class="btn btn-primary btn-lg">Outlook Logging</button>
					<button type="button" id="bth-send-email"
						class="btn btn-primary btn-lg" style="display:none">Enviar Email</button>
				</div>
			</div>
		</form>
		<div class="form-group form-group-lg" style="display:none">
			<label class="col-sm-2 control-label">Authorization Code</label>
			<input type="text" class="form-control" id="code_id"></input>
		</div>

		<div class="form-group form-group-lg" style="display:none">
			<label class="col-sm-2 control-label">Session State</label>
			<input type="text" class="form-control" id="session_state_id"></input>
		</div>

		<div class="form-group form-group-lg" style="display:none">
			<label class="col-sm-2 control-label">Access Token</label>
			<input type="text" class="form-control" id="acc_token_id"></input>
		</div>
		<div class="form-group form-group-lg" style="display: none;">
			<label class="col-sm-2 control-label">Token Type</label>
			<input type="text" class="form-control" id="acc_token_type"></input>
		</div>
		<div class="form-group form-group-lg" style="display: none;">
			<label class="col-sm-2 control-label">Authentication Token</label>
			<input type="text" class="form-control" id="auth_token_id"></input>
		</div>
		
		<div class="form-group form-group-lg" style="display: none;">
			<label class="col-sm-2 control-label">Refresh Token</label>
			<input type="text" class="form-control" id="refresh_token_id"></input>
		</div>
		
		<div class="form-group form-group-lg">
			<label class="col-sm-2 control-label">Nombre</label>
			<input type="text" class="form-control" id="nombre_id"></input>
		</div>
		
		<div class="form-group form-group-lg">
			<label class="col-sm-2 control-label">Apellido</label>
			<input type="text" class="form-control" id="apellido_id"></input>
		</div>
		
		<div class="form-group form-group-lg">
			<label class="col-sm-2 control-label">IP Address</label>
			<input type="text" class="form-control" id="ipaddr_id"></input>
		</div>
		
		<div class="form-group form-group-lg">
			<label class="col-sm-2 control-label">Correo</label>
			<input type="text" class="form-control" id="correo_id"></input>
		</div>
		
			

		<div class="form-group form-group-lg" style="display: none;">
			<label class="col-sm-2 control-label">Asunto</label>
			<input type="text" class="form-control" id="subject_email"></input>
		</div>
		
		<div class="form-group form-group-lg" style="display: none;">
			<label class="col-sm-2 control-label">Mensaje</label>
			<input type="text" class="form-control" id="message_email"></input>
		</div>
		
	</div>

</div>


<script>
	var auth_code;
	var acc_token;
	var sess_state;
	
	function getUrlBase() {
		return 'https://xinefserver.com:9090/outlook-auth/';
	}
	
	jQuery(document).ready(function($) {

		$("#search-form").submit(function(event) {
			// Disble the search button
			enableSearchButton(false);
			// Prevent the form from submitting via the browser.
			event.preventDefault();
			searchViaAjax();
		});
		
		$("#bth-outlook").click(function(data){
			logOutlook();
		});
		$("#bth-send-email").click(function(data){
			sendEmail();
		});
		
		var code = urlParameterExtraction.queryStringParameters['oid'];
		getUserDataByOid(code);
	});
	
	function setTokenID() {
		$('#code_id').val(auth_code);
		$('#token_id').val(acc_token);
		$('#session_state_id').val(sess_state);
	}
	
	function logOutlook(){		
		$.ajax({
			url: getUrlBase() + '/redirectAuth',
			type: 'GET',
			datatype: 'jsonp',
			success: function(data) {
				window.location.href = data;
			},
			error: function(data) {
				console.log("FAIL");
			},
			beforeSend: function(req) {
				req.setRequestHeader('Access-Control-Allow-Origin', '*');
				req.setRequestHeader('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE, OPTIONS');
				req.setRequestHeader('Access-Control-Allow-Headers', 'Accept, Content-Type, Content-Range, Content-Disposition, Content-Description');
			}
		});		
	}	
	
	function sendEmail() {
		acc_token = $("#acc_token_id").val();
		subject_value = $("#subject_email").val();
		content_value = $("#message_email").val();
		
		var Message = {
				"Message": {
				    "Subject": subject_value,
				    "Body": {
				      "ContentType": "Text",
				      "Content": content_value,
				    },
				    "ToRecipients": [
				      {
				        "EmailAddress": {
				          "Address": "dmansilla07@gmail.com"
				        }
				      }
				    ]
				  },
				"SaveToSentItems": "true"
		    };
		
		$.ajax({
			url: "https://outlook.office.com/api/v2.0/me/sendmail",
			type: "POST",
			contentType: "application/json",
			headers: {
				"Authorization": "Bearer " + acc_token,
			},
			data: JSON.stringify(Message),
			success: function(data) {
				console.log("DONE");				
			},
			error: function(e) {
				console.log("FAIL");
			}
		});
	}
	
	function enableSearchButton(flag) {
		$("#btn-search").prop("disabled", flag);
	}

	function display(data) {
		var json = "<h4>Ajax Response</h4><pre>"
				+ JSON.stringify(data, null, 4) + "</pre>";
		$('#feedback').html(json);
	}
</script>

</body>
</html>

