import type { Metadata } from "next";
import Link from "next/link";
import "./globals.css";

export const metadata: Metadata = {
    title: "CampusSphere HOD Dashboard",
    description: "Head of Department management portal",
};

const navItems = [
    { href: "/", label: "Dashboard", icon: "📊" },
    { href: "/department", label: "Department", icon: "🏢" },
    { href: "/faculty", label: "Faculty Performance", icon: "👨‍🏫" },
    { href: "/approvals", label: "Purchase Approvals", icon: "✅" },
    { href: "/attendance", label: "Attendance", icon: "📋" },
    { href: "/grievances", label: "Grievances", icon: "⚠️" },
    { href: "/chatrooms", label: "Chatrooms", icon: "💬" },
    { href: "/meetings", label: "Meetings", icon: "📹" },
    { href: "/ai-insights", label: "AI Insights", icon: "🧠" },
    { href: "/notifications", label: "Notifications", icon: "🔔" },
    { href: "/profile", label: "Profile", icon: "👤" },
];

export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
        <html lang="en">
            <body className="flex min-h-screen bg-gray-50">
                <aside className="w-64 bg-gradient-to-b from-purple-900 to-purple-800 text-white flex flex-col fixed h-full">
                    <div className="p-6 border-b border-purple-700/50">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center text-xl">🎓</div>
                            <div>
                                <h1 className="font-bold text-lg leading-tight">CampusSphere</h1>
                                <p className="text-purple-300 text-xs">HOD Dashboard</p>
                            </div>
                        </div>
                    </div>
                    <nav className="flex-1 py-4 px-3 space-y-1 overflow-y-auto">
                        {navItems.map((item) => (
                            <Link key={item.href} href={item.href} className="flex items-center gap-3 px-4 py-2.5 rounded-lg hover:bg-white/10 transition-colors text-sm">
                                <span className="text-lg">{item.icon}</span>
                                <span>{item.label}</span>
                            </Link>
                        ))}
                    </nav>
                    <div className="p-4 border-t border-purple-700/50">
                        <div className="flex items-center gap-3">
                            <div className="w-9 h-9 rounded-full bg-purple-600 flex items-center justify-center text-sm font-bold">VR</div>
                            <div>
                                <p className="text-sm font-medium">Dr. Venkat R</p>
                                <p className="text-xs text-purple-300">HOD • CSE</p>
                            </div>
                        </div>
                    </div>
                </aside>
                <main className="ml-64 flex-1 p-8">{children}</main>
            </body>
        </html>
    );
}
