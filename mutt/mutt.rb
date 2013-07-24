require 'formula'

class Mutt < Formula
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.21.tar.gz'
  homepage 'http://www.mutt.org/'
  sha1 'a8475f2618ce5d5d33bff85c0affdf21ab1d76b9'

  depends_on 'tokyo-cabinet'
  depends_on 'slang' if ARGV.include? '--with-slang'

  def options
    [
      ['--enable-debug', "Build with debug option enabled"],
      ['--sidebar-patch', "Apply sidebar (folder list) patch"],
      ['--trash-patch', "Apply trash folder patch"],
      ['--with-slang', "Build against slang instead of ncurses"],
      ['--pgp-verbose-mime-patch', "Apply PGP verbose mime patch"],
      ['--initials-patch', "Apply initials patch"],
      ['--quotes-patch', "Apply quotes patch"],
      ['--attach-patch', "Apply attach patch"],
      ['--ifdef-patch', "Apply ifdef patch"],
      ['--echo-patch', "Apply echo patch"],
      ['--indexcolor3-patch', "Apply indexcolor3 patch"],
      ['--multiplesource-patch', "Apply multiple source patch"],
      ['--askpassphrase-patch', "Apply ask passphrase patch"],
      ['--deepif-patch', "Apply deepif patch"],
      ['--dateconditional-patch', "Apply dateconditinal patch"],
    ]
  end

  def patches
    urls = [
      ['--sidebar-patch', 'https://raw.github.com/nedos/mutt-sidebar-patch/master/mutt-sidebar.patch'],
      ['--trash-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/trash_folder-1.5.18.patch'],
      ['--pgp-verbose-mime-patch',
          'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.4.vk.pgp_verbose_mime'],
      ['--ifdef-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.cd.ifdef.2'],
      ['--initials-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.vvv.initials'],
      ['--quotes-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.vvv.quote.2'],
      ['--attach-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/mutt-attach.patch'],
      ['--echo-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.as.echo.2'],
      ['--indexcolor3-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.indexcolor-3+cb.diff'],
      ['--multiplesource-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.cd.source_multiple.3'],
      ['--askpassphrase-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.csev.ask_passphrase.1'],
      ['--deepif-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.dgc.deepif.2'],
      ['--dateconditional-patch', 'https://raw.github.com/skn/homebrew/master/mutt/patches/patch-1.5.21.ats.date_conditional.3'],
    ]

    p = []
    urls.each do |u|
      p << u[1] if ARGV.include? u[0]
    end
    return p
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-warnings",
            "--prefix=#{prefix}",
            "--with-ssl",
            "--with-sasl",
            "--with-gnutls",
            "--with-gss",
            "--enable-imap",
            "--enable-smtp",
            "--enable-pop",
            "--enable-hcache",
            "--with-tokyocabinet",
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
            "--with-homespool=.mbox"]
    args << "--with-slang" if ARGV.include? '--with-slang'

    if ARGV.include? '--enable-debug'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end
end
