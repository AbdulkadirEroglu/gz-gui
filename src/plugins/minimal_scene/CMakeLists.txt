set(SOURCES
  MinimalScene.cc
  MinimalSceneRhi.cc
  MinimalSceneRhiOpenGL.cc
  MinimalSceneRhiVulkan.cc
  EngineToQtInterface.cc
)

set(PROJECT_LINK_LIBS "")
set(PROJECT_COMPILE_DEFINITIONS "")

# Objective-C sources for macOS
if (APPLE)
  set(SOURCES
    ${SOURCES}
    MinimalSceneRhiMetal.mm
  )

  set(PROJECT_LINK_LIBS
    "-framework AppKit"
    "-framework Metal"
  )
endif()

if (TARGET Qt5::WaylandClient)
  list(APPEND PROJECT_LINK_LIBS Qt5::WaylandClient)
  list(APPEND PROJECT_COMPILE_DEFINITIONS GZ_GUI_HAVE_QT5_WAYLAND_CLIENT=1)
endif()

if (TARGET Qt5::WaylandClientPrivate)
  list(APPEND PROJECT_LINK_LIBS Qt5::WaylandClientPrivate)
  list(APPEND PROJECT_COMPILE_DEFINITIONS
    GZ_GUI_HAVE_QT5_WAYLAND_CLIENT_PRIVATE=1)
endif()

gz_gui_add_plugin(MinimalScene
  SOURCES
    ${SOURCES}
    EngineToQtInterface.hh
  QT_HEADERS
    MinimalScene.hh
  PUBLIC_LINK_LIBS
   gz-rendering${GZ_RENDERING_VER}::gz-rendering${GZ_RENDERING_VER}
   gz-transport${GZ_TRANSPORT_VER}::gz-transport${GZ_TRANSPORT_VER}
   ${PROJECT_LINK_LIBS}
)

if (PROJECT_COMPILE_DEFINITIONS)
  target_compile_definitions(MinimalScene PRIVATE
    ${PROJECT_COMPILE_DEFINITIONS})
endif()

# Enable ARC on selected source files
if (APPLE)
  set_source_files_properties(
      MinimalSceneRhiMetal.mm
      PROPERTIES
      COMPILE_FLAGS
          "-fobjc-arc -Wno-nullability-completeness"
  )
endif()
