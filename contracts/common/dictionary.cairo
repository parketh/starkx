%lang starknet

from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import (
    default_dict_new, default_dict_finalize
)
from starkware.cairo.common.dict import (
    dict_write, dict_read, dict_update
)
from starkware.cairo.common.alloc import alloc

# Returns the value for the specified key in a dictionary.
func create_dict{
        range_check_ptr
    } (initial_value : felt) -> (dict : DictAccess*):
    alloc_locals
    # First create an empty dictionary and finalize it.
    # All keys will be set to value of initial_value.
    let (local dict) = default_dict_new(default_value=initial_value)

    # Finalize the dictionary. This ensures default value is correct.
    default_dict_finalize(
        dict_accesses_start=dict,
        dict_accesses_end=dict,
        default_value=initial_value)

    return (dict)
end

# Recursively populates the dictionary with specified key-value pairs.
func add_entries{dict_ptr : DictAccess*}(keys : felt*, values : felt*, len : felt):
    if len == 0:
        return ()
    else:
        dict_write(key=keys[0], new_value=values[0])
        add_entries(keys + 1, values + 1, len - 1)
        return ()
    end    
end

# Reads entry from dictionary
func read_entry{dict_ptr : DictAccess*}(key : felt) -> (val : felt):
    let (val) = dict_read(key=key)
    return (val)
end

# Updates dictionary entry
func update_entry{dict_ptr: DictAccess*}(key, prev_value, new_value):
    dict_update(
        key=key, 
        prev_value=prev_value, 
        new_value=new_value
)
    return ()
end