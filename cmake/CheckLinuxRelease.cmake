
# Copyright (c) 2016-2019, The Karbo developers
#
# This file is part of Karbo.
#
# Karbo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Karbo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Karbo.  If not, see <http://www.gnu.org/licenses/>.


cmake_minimum_required (VERSION 2.8.12)

set (OS_LINUX FALSE)
set (OS_NAME "")
set (OS_VERSION "0.0.0")
set (OS_VERSION_SHORT "0.0")
set (OS_VERSION_MAJOR "0")
set (OS_VERSION_MINOR "0")
set (OS_VERSION_PATCH "0")
set (OS_CODENAME "")
set (OS_DEBIAN FALSE)
set (OS_UBUNTU FALSE)
set (OS_REDHAT FALSE)

if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux" AND NOT ANDROID)
  if (EXISTS "/etc/os-release")
    file(READ "/etc/os-release" _OS_RELEASE)

    # Select OS name
    string(REGEX MATCH "NAME=\"[(A-z)|(a-z)| ]+\"" _OS_NAME "${_OS_RELEASE}")
    if (NOT _OS_NAME)
      string(REGEX MATCH "NAME=[(A-z)|(a-z)]+" _OS_NAME "${_OS_RELEASE}")
    endif()
    if(_OS_NAME)
      string(REPLACE "NAME=" "" _OS_NAME ${_OS_NAME})
      string(REPLACE "\"" "" _OS_NAME ${_OS_NAME})
      string(TOLOWER ${_OS_NAME} _OS_NAME)
      string(FIND ${_OS_NAME} " " _OS_NAME_SEP)
      if (NOT _OS_NAME_SEP EQUAL -1)
        string(SUBSTRING ${_OS_NAME} 0 ${_OS_NAME_SEP} _OS_NAME)
      endif()
      set (OS_NAME ${_OS_NAME})
    endif()

    # Select OS version
    string(REGEX MATCH "VERSION=[(A-z)|(a-z)|(0-9)|\"|\\.]*" _OS_VERSION "${_OS_RELEASE}")
    if(_OS_VERSION)
      if ("${_OS_VERSION}" MATCHES "([1-9]+).([0-9]+).([0-9]+)")
        set(_OS_VERSION_MAJOR ${CMAKE_MATCH_1})
        set(_OS_VERSION_MINOR ${CMAKE_MATCH_2})
        set(_OS_VERSION_PATCH ${CMAKE_MATCH_3})
      elseif ("${_OS_VERSION}" MATCHES "([1-9]+).([0-9]+)")
        set(_OS_VERSION_MAJOR ${CMAKE_MATCH_1})
        set(_OS_VERSION_MINOR ${CMAKE_MATCH_2})
        set(_OS_VERSION_PATCH "0")
      elseif ("${_OS_VERSION}" MATCHES "([1-9]+)")
        set(_OS_VERSION_MAJOR ${CMAKE_MATCH_1})
        set(_OS_VERSION_MINOR "0")
        set(_OS_VERSION_PATCH "0")
      endif()
      string(REGEX MATCH "[1-9][0-9]?|0$" _OS_VERSION_MAJOR "${_OS_VERSION_MAJOR}")
      string(REGEX MATCH "[1-9][0-9]?|0$" _OS_VERSION_MINOR "${_OS_VERSION_MINOR}")
      string(REGEX MATCH "[1-9][0-9]?|0$" _OS_VERSION_PATCH "${_OS_VERSION_PATCH}")

      set (OS_VERSION_MAJOR ${_OS_VERSION_MAJOR})
      set (OS_VERSION_MINOR ${_OS_VERSION_MINOR})
      set (OS_VERSION_PATCH ${_OS_VERSION_PATCH})

      set (OS_VERSION_SHORT "${_OS_VERSION_MAJOR}.${_OS_VERSION_MINOR}")
      set (OS_VERSION "${_OS_VERSION_MAJOR}.${_OS_VERSION_MINOR}.${_OS_VERSION_PATCH}")
    endif()

  endif()
  set (OS_LINUX TRUE)
endif()

# Detecting Linux family
if (OS_LINUX)

  if ((${OS_NAME} STREQUAL "fedora") OR
      (${OS_NAME} STREQUAL "centos"))
    set (OS_REDHAT TRUE)

  elseif ((${OS_NAME} STREQUAL "ubuntu") OR
          (${OS_NAME} STREQUAL "kubuntu") OR
          (${OS_NAME} STREQUAL "lubuntu"))
    set (OS_DEBIAN TRUE)
    set (OS_UBUNTU TRUE)

  elseif ((${OS_NAME} STREQUAL "debian") OR
          (${OS_NAME} STREQUAL "raspbian"))
    set (OS_DEBIAN TRUE)

  endif()
endif()

# Set codename
if (OS_LINUX AND OS_VERSION)

  if (OS_UBUNTU)
    if (${OS_VERSION_SHORT} VERSION_EQUAL "10.4")
      set (OS_CODENAME "Lucid Lynx")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "10.10")
      set (OS_CODENAME "Maverick Meerkat")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "11.4")
      set (OS_CODENAME "Natty Narwhal")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "11.10")
      set (OS_CODENAME "Oneiric Ocelot")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "12.4")
      set (OS_CODENAME "Precise Pangolin")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "12.10")
      set (OS_CODENAME "Quantal Quetzal")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "13.4")
      set (OS_CODENAME "Raring Ringtail")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "13.10")
      set (OS_CODENAME "Saucy Salamander")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "14.4")
      set (OS_CODENAME "Trusty Tahr")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "14.10")
      set (OS_CODENAME "Utopic Unicorn")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "15.4")
      set (OS_CODENAME "Vivid Vervet")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "15.10")
      set (OS_CODENAME "Wily Werewolf")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "16.4")
      set (OS_CODENAME "Xenial Xerus")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "16.10")
      set (OS_CODENAME "Yakkety Yak")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "17.4")
      set (OS_CODENAME "Zesty Zapus")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "17.10")
      set (OS_CODENAME "Artful Aardvark")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "18.4")
      set (OS_CODENAME "Bionic Beaver")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "18.10")
      set (OS_CODENAME "Cosmic Cuttlefish")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "19.4")
      set (OS_CODENAME "Disco Dingo")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "19.10")
      set (OS_CODENAME "Eoan Ermine")
    endif()

  elseif (OS_DEBIAN AND NOT OS_UBUNTU)
    if (${OS_VERSION_SHORT} VERSION_EQUAL "5.0")
      set (OS_CODENAME "Lenny")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "6.0")
      set (OS_CODENAME "Squeeze")
    elseif ((${OS_VERSION_SHORT} VERSION_EQUAL "7.0") OR
            (${OS_VERSION_SHORT} VERSION_EQUAL "7.11") OR
            ((${OS_VERSION_SHORT} VERSION_GREATER "7.0") AND (${OS_VERSION_SHORT} VERSION_LESS "7.11")))
      set (OS_CODENAME "Wheezy")
    elseif ((${OS_VERSION_SHORT} VERSION_EQUAL "8.0") OR
            (${OS_VERSION_SHORT} VERSION_EQUAL "8.11") OR
            ((${OS_VERSION_SHORT} VERSION_GREATER "8.0") AND (${OS_VERSION_SHORT} VERSION_LESS "8.11")))
      set (OS_CODENAME "Jessie")
    elseif ((${OS_VERSION_SHORT} VERSION_EQUAL "9.0") OR
            (${OS_VERSION_SHORT} VERSION_EQUAL "9.9") OR
            ((${OS_VERSION_SHORT} VERSION_GREATER "9.0") AND (${OS_VERSION_SHORT} VERSION_LESS "9.9")))
      set (OS_CODENAME "Stretch")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "10.0")
      set (OS_CODENAME "Buster")
    elseif (${OS_VERSION_SHORT} VERSION_EQUAL "11.0")
      set (OS_CODENAME "Bullseye")
    endif()

  endif()
endif()

# Show info
if (OS_LINUX)
  string(TOUPPER ${OS_NAME} _OS_NAME_UPPER)
  if (OS_DEBIAN)
    message(STATUS "Host machine running on Linux OS ${_OS_NAME_UPPER} ${OS_VERSION} (${OS_CODENAME})")
    if (OS_UBUNTU)
      message(STATUS "OS detected as DEBIAN Linux famly (UBUNTU subfamly)")
    else()
      message(STATUS "OS detected as DEBIAN Linux famly")
    endif()
  elseif (OS_REDHAT)
    message(STATUS "Host machine running on Linux OS ${_OS_NAME_UPPER} ${OS_VERSION}")
    message(STATUS "OS detected as REDHAT Linux famly")
  else()
    message(STATUS "Host machine running on Linux (could not determine family)")
  endif()
endif()

