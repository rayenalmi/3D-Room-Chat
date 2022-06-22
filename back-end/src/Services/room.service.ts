import IRoom from "../Interfaces/room.interface";
import Room from '../Models/room.model';




export class RoomService 
{

public async findByNameAndCategory(name: string,category:string ) : Promise<any>
{
    return Room.find( {name:name ,category:category});
}

public async  createRoom (room : IRoom) : Promise<IRoom>  
{
    const r = await Room.create(room);
    return await r.save()
}

public async findOneRoom(name: string) :Promise<any> 
{
   return await Room.findOne({ name:name });
}

public async findById(id :string) : Promise<any>
{
  return await Room.findById(id).exec();
}
public async  UpdateRoom(id:string, update : IRoom) : Promise<any>
{
    return await Room.findOneAndUpdate({_id:id},update,{upsert: true});
}

public async  findAllByIdOwner(id:any) : Promise<IRoom[]>
{
    return await Room.find({owner:id});
}

public async  findAllByCategory(category:String) : Promise<IRoom[]>
{
    return await Room.find({category:category}).populate('owner');
}

public async  deleteByNameAndCategory(name:String,category:String) : Promise<any>
{
    return await Room.deleteOne({name:name, category:category});
}

public async deleteRoomById(id:String) : Promise<any>
{
    return await await Room.findByIdAndDelete(id);
}

}