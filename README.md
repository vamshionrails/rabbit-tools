
	+---+   +---+
	|   |   |   |
	|   |   |   |
	|   |   |   |       	           _     _       _     _              _
	|   +---+   +-------+	          | |   | |   (_) |   | |            | |
	|                   |	 _ __ __ _| |__ | |__  _| |_  | |_ ___   ___ | |___
	|           +---+   |	| '__/ _` | '_ \| '_ \| | __| | __/ _ \ / _ \| / __|
	|           |   |   |	| | | (_| | |_) | |_) | | |_  | || (_) | (_) | \__ \
	|           +---+   |	|_|  \__,_|_.__/|_.__/|_|\__|  \__\___/ \___/|_|___/
	|                   |
	+-------------------+

Overview
========

This gem provides the 

	rabbitstatus
	
command that dumps the following information about a local RabbitMQ server:

* list_exchanges
* list_bindings
* list queues
* list_connections

Run

	rabbitstatus --help

to see the available options.


You can run 

	rabbitstatus --admin
	
to dump the following information:

* list_users
* list_vhosts
* list_permissions (for each vhost defined)

Documentation
=============

This release was successfully tested against:

* RabbitMQ Server version 1.6.0
* RabbitMQ Server version 1.7.0

See: [http://dev.coravy.com/wiki/display/OpenSource/RabbitMQ+Tools](http://dev.coravy.com/wiki/display/OpenSource/RabbitMQ+Tools)

Copyright
=========

Copyright (c) 2009 Stefan Saasen. See LICENSE for details.
