import CowModel
cows_dict = {}

def add_cow(cowModel: CowModel.CowModel):
    cows_dict[cowModel.cow_id] = cowModel

def delete_cow(cow_id: str):
    del cows_dict[cow_id]

def update_cow(cowModel: CowModel.CowModel):
    cows_dict[cowModel.cow_id] = cowModel

