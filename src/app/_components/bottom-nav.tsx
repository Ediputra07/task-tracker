'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

const tabs = [
  { href: '/today', label: 'Today' },
  { href: '/upcoming', label: 'Upcoming' },
  { href: '/all', label: 'All' },
  { href: '/done', label: 'Done' },
]

export default function BottomNav() {
  const pathname = usePathname()

  return (
    <>
      <div className="h-16" aria-hidden="true" />
      <nav className="fixed bottom-0 left-0 right-0 border-t border-gray-200 bg-white">
        <ul className="flex max-w-2xl mx-auto">
          {tabs.map((tab) => {
            const isActive = pathname === tab.href
            return (
              <li key={tab.href} className="flex-1">
                <Link
                  href={tab.href}
                  className={`block py-3 text-center text-sm ${
                    isActive
                      ? 'bg-gray-100 text-gray-900 font-semibold'
                      : 'text-gray-500'
                  }`}
                >
                  {tab.label}
                </Link>
              </li>
            )
          })}
        </ul>
      </nav>
    </>
  )
}
