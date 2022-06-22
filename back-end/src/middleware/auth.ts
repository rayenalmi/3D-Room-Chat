import { NextFunction, Response } from 'express';

export class auth 
{
jwt = require("jsonwebtoken");

public verifyToken = async (req: any, res: Response, next: NextFunction) => {
    const token =
      req.body.token || req.query.token || req.headers["x-access-token"];
  
    if (!token) {
      return res.status(403).send("A token is required for authentication");
    }
    try {
      const decoded = this.jwt.verify(token,  process.env.TOKEN_KEY || "secret");
      req.user = decoded;
    } catch (err) {
      return res.status(401).send("Invalid Token");
    }
    return next();
  };
  

}