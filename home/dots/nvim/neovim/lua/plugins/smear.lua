require("smear_cursor").setup({
	smear_between_buffers = true,
	stiffness = 0.8,
	trailing_stiffness = 0.6,
	stiffness_insert_mode = 0.7,
	trailing_stiffness_insert_mode = 0.7,
	damping = 0.95,
	damping_insert_mode = 0.95,
	distance_stop_animating = 0.5,
	smear_between_neighbor_lines = true,
	scroll_buffer_space = true,
	smear_insert_mode = false,
})
