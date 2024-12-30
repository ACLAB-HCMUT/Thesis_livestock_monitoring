class Point:
    def __init__(self, longitude: float, latitude: float):
        self.longitude = longitude
        self.latitude = latitude

def is_left(x1, y1, x2, y2, x, y):
    return (x2 - x1) * (y - y1) - (x - x1) * (y2 - y1)

def is_point_in_polygon(point: Point, polygon: list[Point]):
    x, y = point.latitude, point.longitude
    winding_number = 0

    for i in range(len(polygon)):
        x1, y1 = polygon[i].latitude, polygon[i].longitude
        x2, y2 = polygon[(i + 1) % len(polygon)].latitude, polygon[(i + 1) % len(polygon)].longitude

        if y1 <= y:
            if y2 > y and is_left(x1, y1, x2, y2, x, y) > 0:
                winding_number += 1
        else:
            if y2 <= y and is_left(x1, y1, x2, y2, x, y) < 0:
                winding_number -= 1

    return winding_number != 0

class SafeZoneModel:
    def __init__(self, safe_zone_id: str, safe_zone_points: list[Point], sequentialId: str):
        self.safe_zone_id = safe_zone_id
        self.safe_zone_points = safe_zone_points
        self.sequentialId = sequentialId

    def is_point_in_safe_zone(self, point: Point):
        return is_point_in_polygon(point, self.safe_zone_points)
