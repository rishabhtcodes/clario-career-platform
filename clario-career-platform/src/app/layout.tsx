import type { Metadata } from "next";
import { Sora, Inter, Raleway } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/sonner";
import { UserDataProvider } from "@/context/UserDataProvider";
import { InterviewProvider } from "@/context/InterviewContext";

const sora = Sora({
  subsets: ["latin"],
  variable: "--font-sora",
  weight: ["400", "600", "700"],
});

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  weight: ["400", "600", "700"],
});

const raleway = Raleway({
  subsets: ["latin"],
  variable: "--font-raleway",
  weight: ["400", "600", "700"],
});

export const metadata: Metadata = {
  title: "Clario — AI-Powered Career Platform",
  description:
    "Revolutionizing career guidance with 3D roadmaps, personalized AI agents, voice mock interviews, and real-time mentorship.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${sora.variable} ${inter.variable} ${raleway.variable} antialiased `}
      >
        <UserDataProvider>
          <main>{children}</main>
        </UserDataProvider>
        <Toaster />
      </body>
    </html>
  );
}
