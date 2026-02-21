export default function ChatroomsPage() {
    const chatrooms = [
        { name: "CSE Announcements", type: "one-way", members: 504, last: "Mid-semester exam schedule posted", unread: 0 },
        { name: "CSE Faculty Room", type: "faculty-only", members: 24, last: "Dr. Arun: Invigilation duty list shared", unread: 3 },
        { name: "CS301 DBMS — CSE-3A", type: "subject", members: 53, last: "Prof. Lakshmi: Unit 4 notes uploaded", unread: 12 },
        { name: "CS301 DBMS — CSE-3B", type: "subject", members: 49, last: "Student: Doubt about normalization", unread: 5 },
        { name: "CSE-3A General", type: "section", members: 54, last: "CR: Lab schedule change notice", unread: 0 },
        { name: "CSE-2A — Data Structures", type: "subject", members: 57, last: "Dr. Ravi: Assignment 3 posted", unread: 8 },
        { name: "CSE Final Year — Projects", type: "section", members: 156, last: "Phase 2 submission deadline reminder", unread: 15 },
    ];
    return (
        <div><div className="flex items-center justify-between mb-6"><h1 className="text-2xl font-bold">Department Chatrooms</h1><span className="px-3 py-1 bg-purple-100 text-purple-700 rounded-lg text-sm font-medium">👁️ Read-only Access</span></div>
            <div className="space-y-3">{chatrooms.map(c => (<div key={c.name} className="bg-white rounded-2xl p-5 shadow-sm border flex items-center gap-4 hover:border-purple-200 transition cursor-pointer"><div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center text-xl">{c.type === "one-way" ? "📢" : c.type === "faculty-only" ? "👥" : "💬"}</div><div className="flex-1"><p className="font-semibold">{c.name}</p><p className="text-sm text-gray-500 truncate">{c.last}</p><p className="text-xs text-gray-400">{c.members} members • {c.type}</p></div>{c.unread > 0 && <span className="w-7 h-7 bg-purple-600 text-white rounded-full flex items-center justify-center text-xs font-bold">{c.unread}</span>}</div>))}</div></div>
    );
}
