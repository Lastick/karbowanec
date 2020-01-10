// Copyright (c) 2012-2016, The CryptoNote developers, The Bytecoin developers
//
// This file is part of Karbo.
//
// Karbo is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Karbo is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with Karbo.  If not, see <http://www.gnu.org/licenses/>.

#include <cstdio>
#include "CommonLogger.h"

namespace Logging {

namespace {

std::string formatPattern(const std::string& pattern, const std::string& category, Level level, boost::posix_time::ptime time) {
  std::stringstream s;

  for (const char* p = pattern.c_str(); p && *p != 0; ++p) {
    if (*p == '%') {
      ++p;
      switch (*p) {
      case 0:
        break;
      case 'C':
        s << category;
        break;
      case 'D':
        s << time.date();
        break;
      case 'T':
        s << time.time_of_day();
        break;
      case 'L':
        s << std::setw(7) << std::left << ILogger::LEVEL_NAMES[level];
        break;
      default:
        s << *p;
      }
    } else {
      s << *p;
    }
  }

  return s.str();
}

}

void CommonLogger::operator()(const std::string& category, Level level, boost::posix_time::ptime time, const std::string& body) {
  if (level <= logLevel && disabledCategories.count(category) == 0) {
    std::string body2;
    const char *ch_end = "\n";
    const size_t num_cols = 16;
    size_t pos_last = 0;
    while (true) {
      size_t pos_end = body.find(ch_end, pos_last);
      const std::string line = body.substr(pos_last, pos_end - pos_last);
      std::string buff_hex;
      bool is_bin = false;
      for (const char &el : line) {
        if ((el < 0x20 || el > 0x7F) &&
             el != 0x0D &&
             el != 0x09 &&
             el != 0x1F) {
          is_bin = true;
          break;
        }
      }
      if (is_bin) {
        size_t n = 1;
        if (line.size() > num_cols) buff_hex += ch_end;
        for (const char &el : line) {
          char el_hex[3];
          sprintf(el_hex, "%02hhX", el);
          buff_hex += el_hex;
          if (n >= num_cols) {
            buff_hex += ch_end;
            n = 1;
          } else {
            n++;
            buff_hex += " ";
          }
        }
        body2 += buff_hex;
      } else {
        body2 += line;
      }
      pos_last = pos_end + 1;
      if (pos_end == std::string::npos || line.empty()) break;
      else body2 += ch_end;
    }
    if (!pattern.empty()) {
      size_t insertPos = 0;
      if (!body2.empty() && body2[0] == ILogger::COLOR_DELIMETER) {
        size_t delimPos = body2.find(ILogger::COLOR_DELIMETER, 1);
        if (delimPos != std::string::npos) {
          insertPos = delimPos + 1;
        }
      }

      body2.insert(insertPos, formatPattern(pattern, category, level, time));
    }

    doLogString(body2);
  }
}

void CommonLogger::setPattern(const std::string& pattern) {
  this->pattern = pattern;
}

void CommonLogger::enableCategory(const std::string& category) {
  disabledCategories.erase(category);
}

void CommonLogger::disableCategory(const std::string& category) {
  disabledCategories.insert(category);
}

void CommonLogger::setMaxLevel(Level level) {
  logLevel = level;
}

CommonLogger::CommonLogger(Level level) : logLevel(level), pattern("%D %T %L [%C] ") {
}

void CommonLogger::doLogString(const std::string& message) {
}

}
