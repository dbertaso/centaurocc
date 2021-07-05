/*
 * Praya - a system for messages
 *
 * Copyright (C) 1997,1998,1999,2000,2001 Wesley Tanaka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
 * USA.
 */

package wtanaka.praya.yahoo;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import wtanaka.debug.Debug;
import wtanaka.net.Socket;

/**
 * Port helper functions
 *
 * <p>
 * Return to <A href="http://sourceforge.net/projects/praya/">
 * <IMG src="http://sourceforge.net/sflogo.php?group_id=2302&type=1"
 *   alt="Sourceforge" width="88" height="31" border="0"></A>
 * or the <a href="http://praya.sourceforge.net/">Praya Homepage</a>
 *
 * @author Wesley Tanaka
 * @version $Name:  $ $Date: 2003/12/17 01:30:15 $
 **/
public class LibC
{
   /**
    * For ease of porting, convert char* into int
    **/
   public static final int NULL = -1;
   public static final boolean FALSE = false;
   public static final boolean TRUE = true;

   static void free (Object o)
   {
   }

   static void printf (String msg)
   {
      System.out.print (msg);
   }

   /**
    * @bug this is hard coded for its use in YahooLib.java
    **/
   static int snprintf (StringBuffer str, int size, String format,
         String s1, int i1)
   {
      str.setLength(0);

      int stringLoc = format.indexOf ("%s");
      int numberLoc = format.indexOf ("%d");

      Debug.assrt (stringLoc >= 0);
      Debug.assrt (numberLoc >= 0);
      Debug.assrt (numberLoc > stringLoc);

      String part1 = format.substring (0, stringLoc);
      String part2 = format.substring (stringLoc + 2, numberLoc);
      String part3 = format.substring (numberLoc + 2);

      str.append (part1);
      str.append (s1);
      str.append (part2);
      str.append (i1);
      str.append (part3);

      final int toReturn = str.length();
      if (str.length() + 1 > size)
         str.setLength (size-1);
      return toReturn;
   }

   static int atoi (String nptr)
   {
      nptr = nptr.trim();

      int multiplier = 1;

      if (nptr.charAt(0) == '-')
      {
         multiplier = -1;
         nptr = nptr.substring (1);
      }
      else if (nptr.charAt(0) == '+')
      {
         nptr = nptr.substring (1);
      }

      for (int i = 0; i < nptr.length(); ++i)
      {
         if (nptr.charAt (i) < '0' || nptr.charAt(i) > '9')
         {
            nptr = nptr.substring (0,i);
         }
      }

      if (nptr.length() == 0)
         return 0;

      try
      {
         return multiplier * Integer.parseInt (nptr);
      }
      catch (NumberFormatException e)
      {
         e.printStackTrace();
         Debug.assrt (false);
//         System.err.println ("atoi is returning 0 for the following input:");
//         System.err.println (nptr);
//         System.err.println ("at:");
         return 0;
      }
   }

   static boolean isdigit (int ch)
   {
      return Character.isDigit ((char) ch);
   }

   static boolean isprint (int ch)
   {
      return (ch >= ' ' && ch <= '~');
   }

   static boolean strstr (String haystack, String needle)
   {
      return (haystack.indexOf (needle) >= 0);
   }

   static void strcpy (StringBuffer target, String source)
   {
      target.setLength(0);
      target.append (source);
   }

   /**
    * Tested against glibc 2.1.92/string/tester.c
    **/
   static byte[] strncpy (byte[] dest, String source, int n)
   {
      Debug.assrt (dest != null, "YahooLib.strncpy: dest is null");
      Debug.assrt (source != null, "YahooLib.strncpy: source is null");
      int i = 0;
      while (i < source.length() && i < n)
      {
         dest[i] = (byte) source.charAt (i);
         i++;
      }

      while (i < n)
      {
         dest[i++] = (byte) '\0';
      }

      return dest;
   }

   static void strcpy (byte[] target, String source)
   {
      Debug.assrt (target != null, "YahooLib.strcpy: target is null");
      Debug.assrt (source != null, "YahooLib.strcpy: source is null");
      int end = Math.min (target.length-1, source.length());
      for (int i = 0; i < end; ++i)
      {
         target[i] = (byte) source.charAt (i);
      }
      target[target.length-1] = 0;
   }

   static void strcat (StringBuffer target, String source)
   {
      target.append (source);
   }

   static String strdup (String string)
   {
      return string;
   }

   static String strdup (StringBuffer string)
   {
      return string.toString();
   }

   static String strdup (byte[] string)
   {
      try
      {
         return new String (string, "ISO8859_1");
      }
      catch (UnsupportedEncodingException e)
      {
         Debug.assrt (false, e.toString());
      }
      throw new RuntimeException ("Assertion Failure");
   }

   static int strlen (StringBuffer string)
   {
      return string.length();
   }

   static int close(Socket s)
   {
      if (s == null)
      {
         return -1; // EBADF
      }

      try
      {
         s.close();
      }
      catch (IOException e)
      {
         return -1; // EIO
      }
      return 0;
   }

   static int strlen (String string)
   {
      return string.length();
   }

   static int strcmp (String s1, String s2)
   {
      return s1.compareTo (s2);
   }

   static int strncmp (String s1, String s2, int n)
   {
      if (n < s1.length())
         s1 = s1.substring (0,n);
      if (n < s2.length())
         s2 = s2.substring (0,n);
      return strcmp (s1, s2);
   }

   static int strncmp (StringBuffer s1, String s2, int n)
   {
      return strncmp (s1.toString(), s2, n);
   }

   static int strcmp (byte[] s1, String s2)
   {
      int firstNull = -1;
      for (int i = 0; i < s1.length; ++i)
      {
         if (s1[i] == '\0')
         {
            firstNull = i;
            break;
         }
      }
      if (firstNull < 0)
      {
         throw new ArrayIndexOutOfBoundsException ("s1 is not terminated");
      }
      return strcmp (new String (s1, 0, firstNull), s2);
   }

   static int strcasecmp(StringBuffer s1, String s2)
   {
      return strcasecmp(s1.toString(), s2);
   }

   /**
    * Adapted from glibc-2.1.92/sysdeps/generic/strncase.c
    **/
   static int strncasecmp(StringBuffer s1, String s2, int n)
   {
      String string1 = s1.toString();
      s1 = null;

      if (string1.length() > n)
         string1 = string1.substring (0,n);
      Debug.assrt (string1.length() <= n);
      return strcasecmp (string1, s2);
   }

   static int strcasecmp(String s1, String s2)
   {
      return s1.toLowerCase().compareTo (s2.toLowerCase());
   }

   static int strlen (byte[] string)
   {
      for (int i = 0; i < string.length; ++i)
      {
         if (string[i] == (byte) '\0')
         {
            return i;
         }
      }
      return string.length;
   }

   static String fromCStyleByteArray (byte[] string)
   {
      StringBuffer ret = new StringBuffer();
      for (int i = 0; i < string.length; ++i)
      {
         if (string[i] == (byte) '\0')
         {
            return ret.toString();
         }
         ret.append ((char) string[i]);
      }
      return ret.toString();
   }

   static YahooStringTokenizer s_tokenizer = null;
   static String strtok (StringBuffer input, String separators)
   {
      if (input != null)
         s_tokenizer = new YahooStringTokenizer (input.toString(),
               separators);
      return s_tokenizer.nextToken (separators);
   }

   /**
    * The  memchr() function scans the first n bytes of the memory
    * area pointed to by s for the character c.  The  first byte  to
    * match  c  (interpreted as an unsigned character) stops the
    * operation.
    **/
   static String memchr (String input, int c, int n)
   {
      c = c & 0xff;
      for (int i = 0; i < n; ++i)
      {
         if (i >= input.length())
         {
            if (c == '\0')
               return "";
            return null;
         }

         if ((int) input.charAt (i) == c)
            return input.substring (i);
      }
      return null;
   }

   static String strtok_r (StringBuffer input, String separators,
         YahooStringTokenizer tokenizer)
   {
      if (input != null)
         tokenizer.initialize (input.toString(), separators);
      return tokenizer.nextToken (separators);
   }

   private static void equal (byte[] a, String b, int unusedTestNumber)
   {
      Debug.assrt (a != null);
      Debug.assrt (b != null);
      Debug.assrt (0 == strcmp (a, b));
   }

   public static void main (String[] args)
   {
      try
      {
         if (fromCStyleByteArray (new byte[] { 33, 0, 33 }).length() != 1)
         {
            throw new RuntimeException ("Um");
         }

         if (fromCStyleByteArray (new byte[] { 33, 33, 33 }).length() != 3)
         {
            throw new RuntimeException ("Um");
         }

         byte[] one = new byte[50];
         byte[] two = new byte[50];
         String it;

         /* Testing is a bit different because of odd semantics.  */
         it = "strncpy";
         Debug.assrt (strncpy (one, "abc", 4) == one); /* Returned value. */
         equal (one, "abc", 2);         /* Did the copy go right? */
  
         strcpy (one, "abcdefgh");
         strncpy (one, "xyz", 2);
         equal (one, "xycdefgh", 3);       /* Copy cut by count. */

         strcpy (one, "abcdefgh");
         strncpy (one, "xyz", 3);      /* Copy cut just before NUL. */
         equal (one, "xyzdefgh", 4);       

         strcpy (one, "abcdefgh"); 
         strncpy (one, "xyz", 4);      /* Copy just includes NUL. */
         equal (one, "xyz", 5);
         Debug.assrt (one[4] == 'e');
         Debug.assrt (one[5] == 'f');
         Debug.assrt (one[6] == 'g');
         Debug.assrt (one[7] == 'h');
         Debug.assrt (one[8] == '\0');  /* Wrote too much? */

         strcpy (one, "abcdefgh");     
         strncpy (one, "xyz", 5);      /* Copy includes padding. */
         equal (one, "xyz", 7);
         Debug.assrt (one[4] == '\0', one[4] + " == '\0'");
         Debug.assrt (one[5] == 'f');
         Debug.assrt (one[6] == 'g');
         Debug.assrt (one[7] == 'h');
         Debug.assrt (one[8] == '\0');

         strcpy (one, "abc");
         strncpy (one, "xyz", 0);      /* Zero-length copy. */
         equal (one, "abc", 10);

         strncpy (one, "", 2);      /* Zero-length source. */
         equal (one, "", 11); 
         Debug.assrt (one[1] == '\0');
         Debug.assrt (one[2] == 'c');
         Debug.assrt (one[3] == '\0');

         //strcpy (one, "hi there");
         //strncpy (two, one, 9);
         //equal (two, "hi there", 14);      /* Just paranoia. */
         //equal (one, "hi there", 15);      /* Stomped on source? */

         final StringBuffer buffer = new StringBuffer (
               "Set-Cookie: Y=v=1&n=5nud6kumiec9p&l=mj0d0a0/");
         Debug.assrt (0 == strncasecmp (buffer, "Set-Cookie: Y=", 14));

         Debug.assrt (5 == atoi ("5"));
         Debug.assrt (5 == atoi ("5,"));
         Debug.assrt (0 == atoi ("0,2"));
         Debug.assrt (-5 == atoi ("-5"));
         Debug.assrt (0 == atoi (",-5"));
         Debug.assrt (0 == atoi (",5"));
         Debug.assrt (0 == atoi ("xx"));
         Debug.assrt (123 == atoi ("123"));
         Debug.assrt (-123 == atoi ("-123,"));
         Debug.assrt (-123 == atoi ("-123x"));


         final String memchrtestinput = "asdf";
         Debug.assrt ("asdf".equals (memchr (memchrtestinput, 'a', 3)));
         Debug.assrt ("sdf".equals (memchr (memchrtestinput, 's', 3)));
         Debug.assrt ("df".equals (memchr (memchrtestinput, 'd', 3)));
         Debug.assrt (null == memchr (memchrtestinput, 'f', 3));
         Debug.assrt (null == memchr (memchrtestinput, '\0', 3));
         Debug.assrt (null == memchr (memchrtestinput, 'x', 3));
         Debug.assrt ("asdf".equals (memchr (memchrtestinput, 'a', 4)));
         Debug.assrt ("sdf".equals (memchr (memchrtestinput, 's', 4)));
         Debug.assrt ("df".equals (memchr (memchrtestinput, 'd', 4)));
         Debug.assrt ("f".equals (memchr (memchrtestinput, 'f', 4)));
         Debug.assrt (null == memchr (memchrtestinput, '\0', 4));
         Debug.assrt (null == memchr (memchrtestinput, 'x', 4));
         Debug.assrt ("asdf".equals (memchr (memchrtestinput, 'a', 5)));
         Debug.assrt ("sdf".equals (memchr (memchrtestinput, 's', 5)));
         Debug.assrt ("df".equals (memchr (memchrtestinput, 'd', 5)));
         Debug.assrt ("f".equals (memchr (memchrtestinput, 'f', 5)));
         Debug.assrt ("".equals (memchr (memchrtestinput, '\0', 5)));
         Debug.assrt (null == memchr (memchrtestinput, 'x', 5));

         // adapted from test_memchr in glibc-2.2.5
         Debug.assrt (memchr("abcd", 'z', 4) == null);  /* Not found. */
         Debug.assrt (memchr("abcd", 'c', 4).equals("cd")); 
                                                        /* Basic test. */
         Debug.assrt (memchr("abcd", ~0xff|'c', 4).equals ("cd"));
                                             /* ignore highorder bits. */
         Debug.assrt (memchr("abcd", 'd', 4).equals ("d")); 
                                                     /* End of string. */
         Debug.assrt (memchr("abcd", 'a', 4).equals ("abcd"));
                                                         /* Beginning. */
         Debug.assrt (memchr("abcd", '\0', 5).equals (""));   
                                                       /* Finding NUL. */
         Debug.assrt (memchr("ababa", 'b', 5).equals ("baba")); 
                                                     /* Finding first. */
         Debug.assrt (memchr("ababa", 'b', 0) == null);  /* Zero count. */
         Debug.assrt (memchr("ababa", 'a', 1).equals ("ababa")); 
                                                    /* Singleton case. */
         Debug.assrt (memchr("a\203b", 0203, 3).equals ("\203b"));
                                                      /* Unsignedness. */

         // adapted from test_strncmp from glibc 2.2.5
         Debug.assrt (strncmp ("", "", 99) == 0);   
                                                         /* Trivial case. */
         Debug.assrt (strncmp ("a", "a", 99) == 0); 
                                                         /* Identity. */
         Debug.assrt (strncmp ("abc", "abc", 99) == 0);   
                                                       /* Multicharacter. */
         Debug.assrt (strncmp ("abc", "abcd", 99) < 0);   
                                                       /* Length unequal. */
         Debug.assrt (strncmp ("abcd", "abc", 99) > 0);
         Debug.assrt (strncmp ("abcd", "abce", 99) < 0);  
                                                     /* Honestly unequal. */
         Debug.assrt (strncmp ("abce", "abcd", 99) > 0);
         Debug.assrt (strncmp ("a\203", "a", 2) > 0);  
                                                  /* Tricky if '\203' < 0 */
         Debug.assrt (strncmp ("a\203", "a\003", 2) > 0);
         Debug.assrt (strncmp ("abce", "abcd", 3) == 0); 
                                                        /* Count limited. */
         Debug.assrt (strncmp ("abce", "abc", 3) == 0);  
                                                      /* Count == length. */
         Debug.assrt (strncmp ("abcd", "abce", 4) < 0);  
                                                        /* Nudging limit. */
         Debug.assrt (strncmp ("abc", "def", 0) == 0);   
                                                           /* Zero count. */


         System.out.println ("PASS");
      }
      catch (Exception e)
      {
         e.printStackTrace();
         System.out.println ("FAIL");
      }
   }

}
