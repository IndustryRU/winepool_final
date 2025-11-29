import { serve } from "https://deno.land/std@0.177.0/http/server.ts"

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Authorization, Content-Type',
      },
    })
  }

  try {
    // Get user ID from headers
    const userId = req.headers.get('user-id');

    // Validate input
    if (!userId) {
      return new Response(JSON.stringify({ error: 'user-id header is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    // Delete the user from auth table
    const deleteAuthUser = await fetch(`https://wnzewejxrhjnjvyrshzp.supabase.co/auth/v1/admin/users/${userId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InduemV3ZWp4cmhqbmp2eXJzaHpwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDExNDQ2OCwiZXhwIjoyMDc1NjkwNDY4fQ.RTJo3z1tuqTMYizunwRKbdpPzTnKurTO54F19o4eTOo`,
        'Content-Type': 'application/json',
      },
    })

    if (!deleteAuthUser.ok) {
      throw new Error(`Failed to delete user from auth: ${deleteAuthUser.statusText}`)
    }

    // Return success response
    return new Response(JSON.stringify({ message: 'User deleted successfully' }), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    })
  } catch (error) {
    console.error('Error deleting user:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    })
  }
})
