module MDL
  class BorealisPptViewer < BorealisAssetsViewer
    def to_viewer
      {
        "type" => asset.type,
        "thumbnail" => asset.thumbnail,
        "src" => asset.src,
        "text" => "(Download)",
        "transcript" => {
          "label" => "PowerPoint",
          "texts" => []
        }
      }
    end
  end
end
