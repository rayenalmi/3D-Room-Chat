import mongoose, { Schema} from 'mongoose';
import IRoom from '../Interfaces/room.interface';

const RoomSchema: Schema = new Schema(
    {
        owner :{ type:mongoose.Schema.Types.ObjectId, ref:"User", required: true  },
        date :{ type: String,required: true, },
        time :{ type: String,required: true, },
        name: { type: String,required: true},
        all_invits :{ type: [String], ref:"User",required: true, },
        category : { type: String,required: true, },
        code: {type: String , required: true}
    },
    {
        timestamps: true
    }
);



export default mongoose.model<IRoom>('Room', RoomSchema);