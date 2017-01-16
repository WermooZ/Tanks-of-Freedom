var bag

func __get_next_tile_from_path(path):
    if path.size() == 0:
        return null

    return self.bag.abstract_map.get_field(path[1])