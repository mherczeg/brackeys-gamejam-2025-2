# gdlint: disable
@tool
class_name TresGenerator
extends Node

func generate(json_path: String, out_dir: String) -> void:
    var file := FileAccess.open(json_path, FileAccess.READ)
    if file == null:
        push_error("Failed to open JSON: %s" % json_path)
        return
    var text := file.get_as_text()
    file.close()

    var json := JSON.new()
    var parse_result = json.parse(text)
    if parse_result != OK:
        push_error("JSON parse error at line %d: %s" % [json.get_error_line(), json.get_error_message()])
        return

    var entries = json.data
    if typeof(entries) != TYPE_ARRAY:
        push_error("Top-level JSON must be an array of resource entries.")
        return

    for entry in entries:
        if typeof(entry) != TYPE_DICTIONARY:
            continue
        if not entry.has("out_name") or not entry.has("script_path"):
            push_error("Each entry needs 'out_name' and 'script_path'")
            continue

        var out_name: String = entry["out_name"]
        var script_path: String = entry["script_path"]
        var properties: Dictionary = entry.get("properties", {})

        var res := _instantiate_script(script_path)
        if res == null:
            push_error("Failed to load/instantiate script: %s" % script_path)
            continue

        # Assign properties
        for prop_name in properties.keys():
            # Skip Texture2D/icon properties
            if prop_name == "icon":
                continue
            var raw = properties[prop_name]
            var conv = _convert_value(raw)
            res.set(prop_name, conv)

        _ensure_dir(out_dir)
        var out_path = out_dir.path_join(out_name)
        var save_err = ResourceSaver.save(res, out_path)
        if save_err != OK:
            push_error("Failed to save %s (err=%d)" % [out_path, save_err])
        else:
            print("Saved: %s" % out_path)

func _instantiate_script(script_path: String) -> Resource:
    var script_res = ResourceLoader.load(script_path)
    if script_res == null:
        return null
    if script_res is Script:
        return script_res.new()
    return Resource.new()

func _load_resource_from_path(path: String) -> Resource:
    var r = ResourceLoader.load(path)
    if r == null:
        push_warning("Failed to load referenced resource: %s" % path)
    return r

func _convert_value(val):
    var t := typeof(val)
    if t == TYPE_STRING:
        var s: String = val
        if s.ends_with(".tres") or s.ends_with(".res"):
            return _load_resource_from_path(s)
        return s
    elif t == TYPE_ARRAY:
        var arr := []
        for e in val:
            arr.append(_convert_value(e))
        return arr
    elif t == TYPE_DICTIONARY:
        var out := {}
        for k in val.keys():
            var v = val[k]
            var loaded_key
            if typeof(k) == TYPE_STRING and (k.ends_with(".tres") or k.ends_with(".res")):
                loaded_key = _load_resource_from_path(k)
            else:
                loaded_key = k
            out[loaded_key] = _convert_value(v)
        return out
    else:
        return val

func _ensure_dir(dir_path: String) -> void:
    if not DirAccess.dir_exists_absolute(dir_path):
        DirAccess.make_dir_recursive_absolute(dir_path)