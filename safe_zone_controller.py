import SafeZoneModel
safe_zones_dict = {}

def add_safe_zone(safeZoneModel: SafeZoneModel.SafeZoneModel):
    safe_zones_dict[safeZoneModel.safe_zone_id] = safeZoneModel

def delete_safe_zone(safe_zone_id: str):
    del safe_zones_dict[safe_zone_id]

def update_safe_zone(safeZoneModel: SafeZoneModel.SafeZoneModel):
    safe_zones_dict[safeZoneModel.safe_zone_id] = safeZoneModel