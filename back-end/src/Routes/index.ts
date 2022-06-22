import {Application, Request, Response } from 'express';
import {UserRoutes} from './user';
import {RoomRoutes} from './room.route';

export class Routes {
    Agora = require("agora-access-token");

    public  user:UserRoutes = new UserRoutes();
    public  room:RoomRoutes = new RoomRoutes();
    public routes(app:Application): void {
        console.log("routes here")
        app.route('/rtctoken')
        .post((req: Request, res: Response) => {

            const appID = "e003fb59203340e6a99f99650dab89c0";
            const appCertificate = "6e295e9d36a64aedb64543435887e149";
            console.log(req.body);
            const expirationTimeInSeconds = 3600;
            const uid = req.body.uid ; 
            const role = req.body.isPublisher ? this.Agora.RtcRole.PUBLISHER : this.Agora.RtcRole.SUBSCRIBER;
            console.log(role);
            const channel = req.body.channel;
            const currentTimestamp = Math.floor(Date.now() / 1000);
            const expirationTimestamp = currentTimestamp + expirationTimeInSeconds;
          
            const token = this.Agora.RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channel, uid, role, expirationTimestamp);
            res.send({ uid, token });
        });
    
        app.route('/')
        .get((req: Request, res: Response) => {
            res.status(200).send({
                message: "Welcome to the awesome api.. :)!!"
            });
        });
        this.room.routes(app);
        this.user.routes(app);
            
}

}