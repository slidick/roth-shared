extends Object
class_name ROTHPatch

enum {
	GDV_DIRECTORY_PATCH,
	FILES_DIRECTORY_PATCH,
	LANTERN_PATCH,
	SKIP_INTRO_PATCH,
}

const US_PATCH_ZIP: String = "res://assets/US_PATCH.ZIP"

static var DEV_MODE_PATCH: Array = [
	{"offset": 0x22a35, "data": "e89e460000".hex_decode()},
	{"offset": 0x270d8, "data": "e887fdffffe876bdffffc3".hex_decode()},
]
static var NO_BOB_PATCH: Array = [
	{"offset": 0x51794, "data": "eb".hex_decode()},
]
static var CREATIVE_PATCH: Array = [
	{"offset": 0x32d4, "data": "0090".hex_decode()},
	{"offset": 0x2a39b, "data": "e61304".hex_decode()},
	{"offset": 0x5133b, "data": "04a401".hex_decode()},
	{"offset": 0x51735, "data": "979f0100".hex_decode()},
	{"offset": 0x51794, "data": "e953a00100".hex_decode()},
	{"offset": 0x51997, "data": "889d01".hex_decode()},
	{"offset": 0x6b6d0, "data": "9c5056e8000000005e81eed88c05008b8666440100f68010feffff0175085e589de95239fcff0fb68860240000f6c101740383c310f6c104740383eb10c6806124000000c680652400000089d85e83c4049dc3509ce800000000582d2a8d0500f6801f8e05000175079d58e9a063feff9d58c3509ce8000000005981e94a8d05008b91664401000fb68210feffff240188811f8e05009d58e8535ffeff509ce8000000005981e9748d0500c6811f8e0500009d58c3e85e63fcff9c60e8000000005e81ee918d05008bbe664401008a8710feffff240188077438684f4e0000684f444520685645204d6845415449680120435289e08b9f385f000083eb78b904000000ba00000000e89c12fcff83c414eb07c687c808000000619dc3509ce800000000582df38d05008b8066440100f68010feffff0174079d58e9ca5ffeff9d580f84c25ffeff8d3c7fe97a5ffeff00524f544843524541544956453100".hex_decode()},
]
static var SHIFT_RUN_PATCH: Array = [
	{"offset": 0x24f3b, "data": "00".hex_decode()},
]
static var RMB_MOUSELOOK_PATCH: Array = [
	{"offset": 0x25152, "data": "d0e80700000f84e9000000eb050000000000e9dd00".hex_decode()},
	{"offset": 0x296b7, "data": "020f85".hex_decode()},
	{"offset": 0x296dc, "data": "eb08".hex_decode()},
	{"offset": 0x2970c, "data": "75".hex_decode()},
]
static var OPENING_LIGHTING_FIX_PATCH: Array = [
	{"offset": 0x2a466, "data": "e493ffff".hex_decode()},
	{"offset": 0x2a46b, "data": "bdfeffff".hex_decode()},
]
static var OPENING_LIGHTING_FIX_PATCH_BACKUP: Array = [
	{"offset": 0x2a466, "data": "678e0200".hex_decode()},
	#{"offset": 0x2a46b, "data": "bdfeffff".hex_decode()},
]
#static var OPENING_LIGHTING_FIX_PATCH_BETTER: Array = [
	#{"offset": 0x2a470, "data": "9c1404".hex_decode()},
	#{"offset": 0x6b910, "data": "e8494cfcffe8b779feffe80deafbffc3".hex_decode()},
#]

static var PATCH_LIST: Dictionary = {
	"f0f93c7931b9a678469095d3d7f54c04": [
		{ "id": "disable_headbob", "name": "Disable Headbob", "patch": NO_BOB_PATCH, "file": "roth_custom_exe", "category": "Accessibility", "type": "toggle", "default": false  },
		{ "id": "lantern_brightness", "name": "Lantern Brightness", "patch": LANTERN_PATCH, "file": "study1", "category": "Accessibility", "type": "option", "default": 0, "options": ["Default (8)", "Bright (12)", "Brighter (16)", "Brightest (20)"] },
		{ "id": "skip_intro", "name": "Skip Intro", "patch": SKIP_INTRO_PATCH, "file": "dbase100", "category": "Accessibility", "type": "toggle", "default": false },
		
		{ "id": "dev_mode", "name": "Enable Developer Mode", "patch": DEV_MODE_PATCH, "file": "roth_custom_exe", "category": "Fun", "type": "toggle", "default": false },
		{ "id": "creative_mode", "name": "Enable Creative Mode", "patch": CREATIVE_PATCH, "file": "roth_custom_exe", "category": "Fun", "type": "toggle", "default": false  },
		
		{ "id": "shift_run", "name": "Enable Hold Shift to Run", "patch": SHIFT_RUN_PATCH, "file": "roth_custom_exe", "category": "Fixes", "type": "toggle", "default": true  },
		{ "id": "rmb_mouselook", "name": "Enable Right Mouse Button to Look", "patch": RMB_MOUSELOOK_PATCH, "file": "roth_custom_exe", "category": "Fixes", "type": "toggle", "default": true  },
		{ "id": "opening_lighting_fix", "name": "Fix intro lighting bug", "patch": OPENING_LIGHTING_FIX_PATCH, "file": "roth_custom_exe", "category": "Fixes", "type": "toggle", "default": true  },
	],
	"f588469eb868373a339bebb5fba5a9bb": [
		{ "id": "lantern_brightness", "name": "Increase Lantern Brightness", "patch": LANTERN_PATCH, "file": "study1", "category": "Accessibility", "type": "option", "default": 0, "options": ["Default (8)", "Bright (12)", "Brighter (16)", "Brightest (20)"] },
	]
}



#region Offset Patch functions

static func patch_install(install: ROTHInstallation, patch_data: Dictionary, patch_option: Variant) -> void:
	match patch_data.type:
		"toggle":
			if patch_option == true:
				print("Applying patch: ", patch_data.id)
				_patch_file(install.get(patch_data.file), patch_data.patch)
		"option":
			#if patch_option != 0:
			_patch_file(install.get(patch_data.file), patch_data.patch, patch_option)


static func _patch_file(filepath: String, patch: Variant, option: Variant = null) -> void:
	match patch:
		GDV_DIRECTORY_PATCH:
			_patch_gdv_path(filepath, option)
		FILES_DIRECTORY_PATCH:
			_patch_files_path(filepath, option)
		LANTERN_PATCH:
			_patch_lantern(filepath, option)
		SKIP_INTRO_PATCH:
			_skip_intro(filepath)
		_:
			var file := FileAccess.open(filepath, FileAccess.READ_WRITE)
			for row: Dictionary in patch:
				file.seek(row.offset)
				for byte: int in row.data:
					file.store_8(byte)
			file.close()


static func _patch_lantern(filepath: String, option: int) -> void:
	var value: int = 8
	match int(option):
		1:
			value = 16
		2:
			value = 24
		3:
			value = 32
	var file := FileAccess.open(filepath, FileAccess.READ_WRITE)
	file.seek(0xA)
	file.seek(file.get_16() + 0x12)
	file.store_16(value)
	file.close()


static func _skip_intro(filepath: String) -> void:
	pass


static func _patch_gdv_path(filepath: String, md5_sum: String = "") -> void:
	var seek_value: int = 0
	if md5_sum.is_empty():
		md5_sum = FileAccess.get_md5(filepath)
	if (md5_sum == "f0f93c7931b9a678469095d3d7f54c04"
			or md5_sum == "c11ab446c6d92e4e89d557864aa62997"):
		seek_value = 145767
	elif (md5_sum == "d56e7641e8f5d4ec3144bb1c140a7677"
			or md5_sum == "f588469eb868373a339bebb5fba5a9bb"):
		seek_value = 147338
	else:
		push_error("Unknown EXE with MD5: ", md5_sum)
		return
	
	var file := FileAccess.open(filepath, FileAccess.READ_WRITE)
	file.seek(seek_value)
	file.store_8(0x47)
	file.store_8(0x3A)
	file.store_8(0x5C)
	file.store_8(0x00)
	file.close()


static func _patch_files_path(filepath: String, md5_sum: String = "") -> void:
	var patch_values: Array = [
		"d:\\db100.dat".to_ascii_buffer(),
		"d:\\db200.dat".to_ascii_buffer(),
		"d:\\db300.dat".to_ascii_buffer(),
		"d:\\db400.dat".to_ascii_buffer(),
		"d:\\db500.dat".to_ascii_buffer(),
		"d:\\ICONS.ALL".to_ascii_buffer(),
		"d:\\BACKDROP.RAW".to_ascii_buffer(),
	]
	var seek_values: Array = []
	if md5_sum.is_empty():
		md5_sum = FileAccess.get_md5(filepath)
	if md5_sum == "f0f93c7931b9a678469095d3d7f54c04":
		seek_values = [0x7284e, 0x72834, 0x72841, 0x72869, 0x7285c, 0x727cc, 0x727db]
	elif md5_sum == "c11ab446c6d92e4e89d557864aa62997":
		seek_values = [0x7283e, 0x72824, 0x72831, 0x72859, 0x7284c, 0x727bc, 0x727cb]
	elif md5_sum == "f588469eb868373a339bebb5fba5a9bb":
		seek_values = [0x730b6, 0x7309c, 0x730a9, 0x730f2, 0x730e5, 0x73034, 0x73043]
	elif md5_sum == "d56e7641e8f5d4ec3144bb1c140a7677":
		seek_values = [0x73072, 0x73058, 0x73065, 0x730ae, 0x730a1, 0x7302c, 0x7303b]
	else:
		push_error("Unknown EXE with MD5: ", md5_sum)
		return
	
	var file := FileAccess.open(filepath, FileAccess.READ_WRITE)
	for i in range(len(seek_values)):
		file.seek(seek_values[i])
		for byte: int in patch_values[i]:
			file.store_8(byte)
		file.store_8(0)
	file.close()
#endregion

#region Binary Diff Patch functions

static func create_patch_from_folders(a_directory: String, b_directory: String, out_directory: String, erase_testfile: bool = true) -> void:
	var start_time: float = Time.get_ticks_msec()
	var a_dir := DirAccess.get_files_at(a_directory)
	var b_dir := DirAccess.get_files_at(b_directory)
	
	var found: bool = false
	for filename: String in a_dir:
		if filename not in b_dir:
			print("Found %s in A not in B" % filename)
			found = true
	for filename: String in b_dir:
		if filename not in a_dir:
			print("Found %s in B not in A" % filename)
			found = true
	
	if found:
		return
	
	DirAccess.make_dir_recursive_absolute(out_directory.path_join("PATCHES"))
	DirAccess.make_dir_recursive_absolute(out_directory.path_join("TEST"))
	
	for filename: String in a_dir:
		var a_filepath: String = a_directory.path_join(filename)
		var b_filepath: String = b_directory.path_join(filename)
		if FileAccess.get_md5(a_filepath) == FileAccess.get_md5(b_filepath):
			pass
			#Console.print("%s files same." % filename)
		else:
			print("%s:\nCreating patch..." % filename)
			var patch_filepath: String = out_directory.path_join("PATCHES").path_join(filename.replace(".", "_")+".PATCH")
			var out_filepath: String = out_directory.path_join("TEST").path_join(filename)
			_create_patch(a_filepath, b_filepath, patch_filepath)
			print("Applying patch...")
			if not _apply_patch(a_filepath, patch_filepath, out_filepath, b_filepath):
				return
			if erase_testfile:
				DirAccess.remove_absolute(out_filepath)
	
	print("Zipping...")
	var zip := ZIPPacker.new()
	var err: Error = zip.open(out_directory.path_join("US_PATCH.ZIP"))
	zip.compression_level = ZIPPacker.COMPRESSION_BEST
	if err == OK:
		for filename: String in DirAccess.get_files_at(out_directory.path_join("PATCHES")):
			print(filename)
			var patch: PackedByteArray = FileAccess.get_file_as_bytes(out_directory.path_join("PATCHES").path_join(filename))
			zip.start_file(filename, 420, Time.get_unix_time_from_datetime_string("2026-07-01"))
			zip.write_file(patch)
			zip.close_file()
		zip.close()
	
	for file in DirAccess.get_files_at(out_directory.path_join("PATCHES")):
		DirAccess.remove_absolute(out_directory.path_join("PATCHES").path_join(file))
	DirAccess.remove_absolute(out_directory.path_join("PATCHES"))
	for file in DirAccess.get_files_at(out_directory.path_join("TEST")):
		DirAccess.remove_absolute(out_directory.path_join("TEST").path_join(file))
	DirAccess.remove_absolute(out_directory.path_join("TEST"))
	
	print("Time: %.1fs" % ((Time.get_ticks_msec()-start_time)/1000.0))


static func apply_us_patch(in_directory: String, out_directory: String) -> Error:
	return OK
	var zip := ZIPReader.new()
	var err := zip.open(US_PATCH_ZIP)
	if err != OK:
		return err
	print(zip.get_files())
	zip.close()
	return err


static func _apply_patch(in_filepath: String, patch_filepath: String, out_filepath: String, test_filepath: String = "") -> Variant:
	var in_file: PackedByteArray = FileAccess.get_file_as_bytes(in_filepath)
	var patch_file: PackedByteArray = FileAccess.get_file_as_bytes(patch_filepath)
	
	var in_pos: int = 0
	var patch_pos: int = 0
	while patch_pos < patch_file.size():
		var byte: int = patch_file[patch_pos]
		patch_pos += 1
		if byte & 0x80:
			var skip: int = byte - 0x80
			in_pos += skip
		else:
			for i in range(byte):
				if in_pos >= in_file.size():
					in_file.append(patch_file[patch_pos])
				else:
					in_file[in_pos] = patch_file[patch_pos]
				in_pos += 1
				patch_pos += 1
	
	if in_pos < in_file.size():
		in_file.resize(in_pos)
	
	var file := FileAccess.open(out_filepath, FileAccess.WRITE)
	file.store_buffer(in_file)
	file.close()
	
	if not test_filepath.is_empty():
		print("Testing patch...")
		if FileAccess.get_md5(test_filepath) == FileAccess.get_md5(out_filepath):
			print("passed.\n")
			return true
		else:
			print("failed.\n")
			return false
	return null


static func _create_patch(a_filepath: String, b_filepath: String, patch_filepath: String) -> void:
	var a: PackedByteArray = FileAccess.get_file_as_bytes(a_filepath)
	var b: PackedByteArray = FileAccess.get_file_as_bytes(b_filepath)
	
	var data := PackedByteArray()
	var same_count: int = 0
	var diff_count: int = 0
	for i in range(min(a.size(),b.size())):
		
		if same_count > 0 and a[i] != b[i]:
			while same_count > 0x7F:
				data.append(0x80 + 0x7F)
				same_count -= 0x7F
			data.append(0x80 + same_count)
			same_count = 0
		
		if (diff_count > 0 and a[i] == b[i]) or diff_count == 0x7F:
			data.append(0x0 + diff_count)
			for j in range(diff_count, 0, -1):
				data.append(b[i-j])
			diff_count = 0
		
		if a[i] == b[i]:
			same_count += 1
		else:
			diff_count += 1
	
	# Final
	if same_count > 0:
		while same_count > 0x7F:
			data.append(0x80 + 0x7F)
			same_count -= 0x7F
		data.append(0x80 + same_count)
		same_count = 0
	
	elif diff_count > 0:
		data.append(0x0 + diff_count)
		for j in range(diff_count, 0, -1):
			data.append(b[min(a.size(),b.size())-j])
		diff_count = 0
	
	# Append remainder
	if b.size() > a.size():
		var full: int = floori((b.size() - a.size()) / float(0x7F))
		var mod: int = (b.size() - a.size()) % 0x7F
		var pos: int = a.size()
		if full > 0:
			pos += 0x7F
			for i in range(full):
				data.append(0x0 + 0x7F)
				for j in range(0x7F, 0, -1):
					data.append(b[pos-j])
				pos += 0x7F
			pos -= 0x7F
		pos += mod
		data.append(0x0 + mod)
		for j in range(mod, 0, -1):
			data.append(b[pos-j])
	
	elif a.size() > b.size():
		pass
	
	
	var patch_file := FileAccess.open(patch_filepath, FileAccess.WRITE)
	patch_file.store_buffer(data)
	patch_file.close()

#endregion
