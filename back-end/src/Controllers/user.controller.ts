import { NextFunction, Request, Response } from 'express';
import User from '../Models/user';
import * as bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import IUser from '../Interfaces/user';
import { UserService } from '../Services/service.user';
import { auth } from '../middleware/auth';
dotenv.config();
export class ControllerUser {

public userService:UserService = new UserService();
public a : auth = new auth();
jwt = require("jsonwebtoken");

public createUser = async (req: Request, res: Response, next: NextFunction) => {

  try {
  const user:IUser= req.body;
       // Validate user input 
       if (!(user.email && user.password && user.firstName && user.lastName)) {
          res.status(400).send("All input is required");
        }

    // check if user already exist
    // Validate if user exist in our database
    const oldUser = await this.userService.findOneUser(user.email);

    if (oldUser) {
      return res.status(409).send("User Already Exist. Please Login");
    }
  
  const salt = await bcrypt.genSaltSync(10);
  const encryptedUserPassword = await bcrypt.hash(user.password, salt);

  // Create token
  const token = this.jwt.sign(
      { _id: user._id, email : user.email },
      process.env.TOKEN_KEY || "secret"
    );

      // save user token
      user.token = token;
      user.password = encryptedUserPassword;

  
  return await this.userService.createUser(user)
      .then((result) => {
          return res.status(200).json({
              user: result
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



public loginUser = async (req :Request , res:Response,next:NextFunction)  =>
{
        try {
        // Get user input
        const userBody:IUser = req.body;
        // Validate user input
        if (!(userBody.email && userBody.password)) {
          res.status(400).send("All input is required");
        }
        // Validate if user exist in our database
        const oldUser = await this.userService.findOneUser(userBody.email);
        if (oldUser && (await bcrypt.compare(userBody.password, oldUser.password))) {
          // Create token
          const token = this.jwt.sign(
            { _id: oldUser._id, email :userBody.email },
            process.env.TOKEN_KEY || 'secret' ,
            {
              expiresIn: "50h",
            }
          );
          // save user token
          oldUser.token = token;
    
          // user
          res.status(200).json(oldUser);
        }
        else if (oldUser == null)
        {
          res.status(301).send({message:"email does not exist"});
        }
        else
        {
          res.status(401).send({message:"password incorect"});
        }

    }
    catch(e) {
      next();
    }
      
};
public getUserById = async (req: any, res: Response, next: NextFunction) => {
  try {
  // Get user input
  const id =req.user._id ;
  const oldUser = await this.userService.findUserId(id);
  if(oldUser)
  {
    res.status(200).json(oldUser);
  }
  else
  {
    res.status(401).send({message:"user not found"});
  }

  }catch(e)
    {
      next();
    }
};

public updatePassword = async (req: any, res: Response, next: NextFunction) => {
  try {
  // Get user input

  //console.log(req.decode);
  const id =req.user._id ;
  const userBody:IUser = req.body;
  //console.log(id);
  //console.log(userBody);
  const oldUser = await this.userService.findUserId(id);
  const salt = await bcrypt.genSaltSync(10);
  const encryptedUserPassword = await bcrypt.hash(userBody.password, salt);
  if(oldUser)
  {
  //console.log(oldUser+encryptedUserPassword);
  oldUser.password = encryptedUserPassword;
 /* User.findOneAndUpdate({_id:id},oldUser,{upsert: true}, function(err, doc) {
      if (err) return res.status(500).send({error: err});
      return res.send('Succesfully Updated.');
  });*/

  return this.userService.UpdateUser(id,oldUser)
      .then((result) => {
        return res.status(201).json({
            user: result
        });
    })
    .catch((error) => {
        return res.status(500).json({
            message: error.message,
            error
        });
    });


  }
  else
  {
    res.status(401).send({message:"user not found"});
  }

  }catch(e)
    {
      next();
    }
};
}
