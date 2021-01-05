#pragma once

#include "Ioman_Device.h"
#include "filesystem_def.h"

namespace Iop
{
	namespace Ioman
	{
		class CHardDiskDevice : public CDevice
		{
		public:
			CHardDiskDevice();
			
			Framework::CStream* GetFile(uint32, const char*) override;
			Directory GetDirectory(const char*) override;

		private:
			fs::path m_basePath;
		};
	
		class CHardDiskPartition : public Framework::CStream
		{
		public:
			void Seek(int64, Framework::STREAM_SEEK_DIRECTION) override;
			uint64 Tell() override;
			uint64 Read(void*, uint64) override;
			uint64 Write(const void*, uint64) override;
			bool IsEOF() override;
		};
	}
}
