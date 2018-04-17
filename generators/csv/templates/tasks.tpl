{% for i, task in ipairs(tasks) do %}
"{{task.fileName}}", {{task.lineNumber}}, "{{task.tag}}", "{{task.message}}"
{% end %}

