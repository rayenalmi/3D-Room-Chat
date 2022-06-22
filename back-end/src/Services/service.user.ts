import IUser from "../Interfaces/user";
import User from "../Models/user";

export class UserService
{   
    public async  findOneUser(email: string) :Promise<any> 
    {
    return await User.findOne({ email:email });
    }

    public async  createUser (user : IUser) : Promise<IUser>
    {
        const u = await User.create(user);
        return await u.save();
    }
    
    public async  findUserId(id: string) :Promise<any> 
    {
    return await User.findOne({ _id:id});
    }

    public async  UpdateUser(id:string, user :IUser) : Promise<any>
{
    return  User.findOneAndUpdate({_id:id},user,{upsert: true});
}

}









