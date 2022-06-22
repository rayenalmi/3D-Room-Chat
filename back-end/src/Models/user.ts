import mongoose, { Schema } from 'mongoose';
import IUser from '../Interfaces/user';

const UserSchema: Schema = new Schema(
    {
        firstName: { type: String,required: true, },
        lastName: { type: String,required: true, },
        email: { type: String, unique: true ,required: true,},
        password: { type: String,required: true, },
        token: { type: String ,required: true, },
    },
    {
        timestamps: true
    }
);

UserSchema.index({ email: 1 });


export default mongoose.model<IUser>('User', UserSchema);