{application, 'echo', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['echo','echo_app','echo_handler','echo_sup']},
	{registered, [echo_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {echo_app, []}},
	{env, []}
]}.