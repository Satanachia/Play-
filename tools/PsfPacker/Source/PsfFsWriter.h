#ifndef _PSFFSWRITER_H_
#define _PSFFSWRITER_H_

#include "StdStream.h"
#include "PsfFsDescription.h"
#include <boost/filesystem/path.hpp>

namespace PsfFs
{
	class CWriter
	{
	public:
		static void					Write(Framework::CStdStream&, const DirectoryPtr&, const boost::filesystem::path&);

	private:
									CWriter(const boost::filesystem::path&, uint64);
		virtual						~CWriter();

		struct DIRENTRY
		{
			uint8		name[36];
			uint32		offset;
			uint32		uncompressedSize;
			uint32		blockSize;
		};

		void						WriteFile(Framework::CStdStream&, const FilePtr&, DIRENTRY*);
		void						WriteDirectory(Framework::CStdStream&, const DirectoryPtr&, DIRENTRY*);

		boost::filesystem::path		m_basePath;
		uint64						m_baseOffset;
	};
}

#endif
