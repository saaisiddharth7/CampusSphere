export default function MeetingsPage() {
    const meetings = [
        { title: "Monthly Faculty Review", type: "Department", date: "Today, 4:00 PM", duration: "60 min", status: "upcoming", attendees: 24 },
        { title: "Curriculum Committee — Sem 4", type: "Committee", date: "Feb 24, 11:00 AM", duration: "90 min", status: "upcoming", attendees: 8 },
        { title: "Lab Equipment Budget Discussion", type: "Department", date: "Feb 19, 3:00 PM", duration: "45 min", status: "completed", attendees: 12 },
        { title: "NAAC Preparation Meeting", type: "All-Hands", date: "Feb 15, 10:00 AM", duration: "120 min", status: "completed", attendees: 24 },
        { title: "Placement Coordination", type: "Committee", date: "Feb 10, 2:00 PM", duration: "60 min", status: "completed", attendees: 6 },
    ];
    return (
        <div><div className="flex items-center justify-between mb-6"><h1 className="text-2xl font-bold">Department Meetings</h1><button className="px-4 py-2 bg-purple-600 text-white rounded-xl text-sm font-medium hover:bg-purple-700">+ Schedule</button></div>
            <div className="space-y-3">{meetings.map(m => (<div key={m.title} className="bg-white rounded-2xl p-5 shadow-sm border flex items-center gap-4"><div className={`w-12 h-12 rounded-xl flex items-center justify-center text-xl ${m.status === "upcoming" ? "bg-purple-100" : "bg-gray-100"}`}>{m.type === "All-Hands" ? "👥" : m.type === "Committee" ? "🤝" : "📹"}</div><div className="flex-1"><p className="font-semibold">{m.title}</p><p className="text-sm text-gray-500">{m.type} • {m.date} • {m.duration}</p><p className="text-xs text-gray-400">{m.attendees} attendees</p></div>{m.status === "upcoming" ? <button className="px-4 py-2 bg-purple-600 text-white rounded-xl text-sm font-medium hover:bg-purple-700">Start</button> : <button className="px-4 py-2 bg-gray-100 text-gray-600 rounded-xl text-sm font-medium hover:bg-gray-200">Watch</button>}</div>))}</div></div>
    );
}
