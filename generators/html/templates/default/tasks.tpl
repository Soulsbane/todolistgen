<table><caption><b>{{fileName}}</b></caption>
	<col width="10%"><col width="10%"><col width="80%">
	<tr><th>Tag</th><th>Line Number</th><th>Message</th></tr>
	{% for i, task in ipairs(tasks) do %}
	<tr>
		<td>{{task.tag}}</td>
		<td>{{task.lineNumber}}</td>
		<td>{{task.message}}</td>
	</tr>
	{% end %}
</table><br/>
