export default function NotificationsPage() {
    const notifications = [
        { title: "Purchase request approved by Admin", sub: "Books — Database Internals. Order placed.", time: "2h ago", icon: "✅", read: false },
        { title: "Grievance escalated to you", sub: "Lab AC not working — raised by Rahul Kumar", time: "3h ago", icon: "⚠️", read: false },
        { title: "Faculty leave request", sub: "Dr. Arun K — Medical leave Feb 25-26", time: "5h ago", icon: "📅", read: false },
        { title: "New AI dropout alert", sub: "2 new students flagged critical risk in CSE-3A", time: "1d ago", icon: "🧠", read: true },
        { title: "Attendance below threshold", sub: "CSE-2B avg attendance dropped to 78.3%", time: "1d ago", icon: "📉", read: true },
        { title: "NAAC meeting reminder", sub: "Tomorrow, 10:00 AM — all faculty required", time: "2d ago", icon: "📋", read: true },
    ];
    return (
        <div><div className="flex items-center justify-between mb-6"><h1 className="text-2xl font-bold">Notifications</h1><button className="text-purple-600 text-sm font-medium hover:underline">Mark all read</button></div>
            <div className="space-y-3">{notifications.map(n => (<div key={n.title} className={`bg-white rounded-2xl p-5 shadow-sm border flex items-center gap-4 ${!n.read ? "border-purple-200 bg-purple-50/30" : "border-gray-100"}`}><span className="text-2xl">{n.icon}</span><div className="flex-1"><p className={`text-sm ${!n.read ? "font-bold" : "font-medium"}`}>{n.title}</p><p className="text-sm text-gray-500">{n.sub}</p></div><span className="text-xs text-gray-400">{n.time}</span></div>))}</div></div>
    );
}
