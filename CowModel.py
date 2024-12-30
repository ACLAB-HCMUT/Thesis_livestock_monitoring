class CowModel:
    def __init__(
            self, 
            cow_id: str, 
            cow_addr: int | None,
            safe_zone_id: str | None,
        ):
        
        self.cow_id = cow_id
        self.cow_addr = cow_addr
        self.safe_zone_id = safe_zone_id
        self.number_of_failed = 0
