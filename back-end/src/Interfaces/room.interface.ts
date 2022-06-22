import { Document } from 'mongoose';
import IUser from './user';

export default interface IRoom extends Document {
   _id: string;
   owner : string;
   date : string;
   time :string; 
   name: string;
   all_invits : Array<string>;
   category : string;
   code:string;
}