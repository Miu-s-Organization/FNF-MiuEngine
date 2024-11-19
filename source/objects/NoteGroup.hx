package objects;

import flixel.util.FlxSort;
import objects.Note;

class NoteGroup extends FlxTypedGroup<Note> {
	var pool:Array<Note> = [];
	
	public function pushToPool(object:Note)
	{
		pool.push(object);
	}

	var notePopped:Note = new Note(0, 0);
	public inline function spawnNote(chartData:Note)
	{
		notePopped = pool.pop();
		if (notePopped == null)
		{
			notePopped = new Note(0, 0);
			members.push(notePopped);
			length++;
		}
		else notePopped.exists = true;
		notePopped.setupNoteData(chartData);
	}
}