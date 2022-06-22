import { NextFunction, Request, Response } from 'express';
import dotenv from 'dotenv';
import { RoomService } from '../Services/room.service';
import IRoom from '../Interfaces/room.interface';
dotenv.config();
export class ControllerRoom {

public roomService:RoomService= new RoomService();
   
public UpdateRoomById = async (req: Request, res:Response,next:NextFunction) => 
{
    try {
    const id = req.params.id;
    const Room:IRoom = req.body;
    Room.category = Room.category.charAt(0).toUpperCase() + Room.category.slice(1);
    console.log(Room);
    const Oldroom = await this.roomService.findById(id);
    console.log(Oldroom);
    if(Oldroom.name != Room.name || Oldroom.category != Room.category )
    {
    const room = await this.roomService.findByNameAndCategory(Room.name,Room.category);
    if(room.length!=0)
    {
        return res.status(409).send({message:"Room Already Exist in this category."});
    }
    
    }
      return await this.roomService.UpdateRoom(id,Room)
      .then((result) => {
        return res.status(201).json({
            room: result
        });
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });
    }
    catch(e)
    {
        next();
    }

}

public createRoom = async (req :any , res:Response, next:NextFunction)  =>
{
    try {
        // Get user input
        const Room:IRoom = req.body;

        Room.owner=req.user._id;
        Room.category = Room.category.charAt(0).toUpperCase() + Room.category.slice(1);
        // validate all input 
        if(  !Room.owner || !Room.date || !Room.time || !Room.name || !Room.all_invits || !Room.category)
        {
            res.status(400).send({message:"All input is required"});
        }
        console.log(Room);

        const Oldroom = await this.roomService.findByNameAndCategory(Room.name,Room.category);
        if(Oldroom.length!=0)
        {
            return res.status(409).send({message:"Room Already Exist In This Category."});
        }
      Room.category = Room.category.charAt(0).toUpperCase() + Room.category.slice(1);
      console.log(Room.category);
      return this.roomService.createRoom(Room)
      .then((result) => {
        return res.status(201).json({
            room: result
        });
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });
    }
    catch(e)
    {
        next();
    }

};


public getRoomById = async (req: Request ,res:Response,next:NextFunction) => 
{
    try {
     const id =req.params.id;
     return await this.roomService.findById(id)
     .then(result => {
        return res.status(201).json({
            room: result
        });
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });
    }
    catch(err)
    {
        next();
    }
    
}

public getRoomByIdOwner = async (req: any ,res:Response,next:NextFunction) => 
{
    try {
     const id =req.user._id;
     return await this.roomService.findAllByIdOwner(id)
     .then(result => {
        return res.status(201).json({
            room: result
        });
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });
    }
    catch(err)
    {
        next();
    }
    
}

public getRoomByCategory = async (req: Request ,res:Response,next:NextFunction) => 
{
    try {
     const category =req.params.category;
     return await this.roomService.findAllByCategory(category)
     .then(result => {
        return res.status(201).json({
            room: result
        });
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });
    }
    catch(err)
    {
        next();
    }
    
}
public deleteRoom = async (req: Request ,res:Response,next:NextFunction) => 
{
try {
    const id =req.params.id ;
    //const category  =req.params.category;
    //const room = await this.roomService.findByNameAndCategory(name,category);
    
     return await this.roomService.deleteRoomById(id)
      .then((result) => {
        return  res.status(200).send({message:"room deleted"});
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });  
    }catch(e)
      {
        next();
      }
    }

}