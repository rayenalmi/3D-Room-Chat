import express ,{Response,Request} from 'express';
import {ControllerUser} from '../Controllers/user.controller';
import { auth } from '../middleware/auth';

export  class UserRoutes 
{
    public auth : auth = new auth();
    public controllerUser: ControllerUser = new ControllerUser();
    public routes(app:express.Application): void  {
        app.post('/create/user', this.controllerUser.createUser);  
        app.post('/login/user', this.controllerUser.loginUser);
        app.get('/get/userbyid/',this.auth.verifyToken,this.controllerUser.getUserById);
        app.put('/user/update/',  this.auth.verifyToken, this.controllerUser.updatePassword);
    }

}
