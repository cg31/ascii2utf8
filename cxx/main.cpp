#include "stdafx.h"

using namespace std;
using namespace boost;

namespace fs = boost::filesystem;
namespace alg = boost::algorithm;

static const BYTE utf8BOM[] = { 0xEF, 0xBB, 0xBF };

int main(int argc, char* argv[])
{
	fs::path p = fs::current_path();

	for (fs::recursive_directory_iterator iter(p); iter != fs::recursive_directory_iterator(); ++iter)
	{
		if (fs::is_regular(iter->status()))
		{
			fs::path file_path = iter->path();

			std::string ext = extension(iter->path());
            if (ext == _T(".htm") || ext == _T(".html") || ext == _T(".xhtml"))
			{
                fs::basic_ifstream<BYTE> instream(file_path, std::ios_base::in | std::ios_base::binary);
                if (!instream.is_open())
                {
                    assert(0);
                    std::cout << "Failed to open input file\n";
                    return 1;
                }

                int fsize = fs::file_size(file_path);
                
                std::vector<BYTE> str_file;
                str_file.resize(fsize + 1);

                instream.read(str_file.data(), fsize);

                instream.close();

                if (str_file.size() > _countof(utf8BOM) && !memcmp(str_file.data(), utf8BOM, _countof(utf8BOM)))
                {
                    continue;
                }

                fs::basic_ofstream<BYTE> outstream(file_path, std::ios_base::out | std::ios_base::binary);
                if (!outstream.is_open())
                {
                    assert(0);
                    std::cout << "Failed to open output file\n";
                    return 1;
                }

                std::cout << file_path.string() << std::endl;

                outstream.write(utf8BOM, _countof(utf8BOM));
                outstream.write(str_file.data(), fsize);

                outstream.close();
			}
		}
	}

	return 0;
}


